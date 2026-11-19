import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart"
    show ApiV1AuthLoginPost$RequestBody, LoginResponse;
import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/base_api_client.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/google_sign_in_service.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";
import "package:test/test.dart";

class MockIMembersRepository extends Mock implements IMembersRepository {}

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockGoogleSignInService extends Mock implements GoogleSignInService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockIBaseApiClient extends Mock implements IBaseApiClient {
  @override
  late Dio client;
}

void main() {
  late AuthRepository authRepository;
  late MockIMembersRepository membersRepository;
  late MockAuthApiClient authApiClient;
  late MockGoogleSignInService googleSignInService;
  late MockSecureStorageService secureStorageService;
  late BaseApiClient baseApiClient;
  late AuthListenable authListenable;

  /// Number of `GET /Members/uuid/{uuid}` calls — the only network call the
  /// router redirect can trigger.
  var memberCalls = 0;

  /// What the fake secure storage holds. The logout path clears the uuid.
  String? storedUuid;
  String? storedToken;

  final member = MembersEntity(
    id: 1,
    name: "Ana",
    email: "ana@test.com",
    uuid: "user-uuid",
  );

  setUpAll(() {
    registerFallbackValue(
      ApiV1AuthLoginPost$RequestBody(
        email: "fallback@test.com",
        password: "fallback",
      ),
    );
  });

  setUp(() {
    memberCalls = 0;
    storedUuid = "user-uuid";
    storedToken = "token";

    membersRepository = MockIMembersRepository();
    authApiClient = MockAuthApiClient();
    googleSignInService = MockGoogleSignInService();
    secureStorageService = MockSecureStorageService();
    when(
      () => secureStorageService.saveRefreshToken(any()),
    ).thenAnswer((_) async => const Success(true));
    when(() => authApiClient.logout(any())).thenAnswer(
      (_) async => Success.unit(),
    );
    baseApiClient = BaseApiClient();
    authListenable = AuthListenable();

    when(() => secureStorageService.fetchToken()).thenAnswer(
      (_) async => storedToken == null
          ? Failure(Exception("Token not found"))
          : Success(storedToken!),
    );
    when(() => secureStorageService.fetchUuid()).thenAnswer(
      (_) async => storedUuid == null
          ? Failure(Exception("User UUID not found"))
          : Success(storedUuid!),
    );
    when(() => secureStorageService.saveUuid(any())).thenAnswer((
      invocation,
    ) async {
      storedUuid = invocation.positionalArguments.first as String?;
      return const Success(true);
    });
    when(() => secureStorageService.saveToken(any())).thenAnswer((
      invocation,
    ) async {
      storedToken = invocation.positionalArguments.first as String?;
      return const Success(true);
    });
    when(() => membersRepository.getByUuidAsync(any())).thenAnswer((_) async {
      memberCalls++;
      return Success(member);
    });

    authRepository = AuthRepository(
      membersRepository: membersRepository,
      authApiClient: authApiClient,
      googleSignInService: googleSignInService,
      baseApiClient: baseApiClient,
      sharedPreferencesService: secureStorageService,
      authListenable: authListenable,
    );
  });

  group("session validity cache", () {
    test("concurrent validations hit the members endpoint only once", () async {
      final results = await Future.wait([
        authRepository.validateSession(),
        authRepository.validateSession(),
      ]);

      expect(results, everyElement(isTrue));
      expect(memberCalls, equals(1));
    });

    test("a 401 invalidates the cached session validity", () async {
      expect(await authRepository.validateSession(), isTrue);
      expect(memberCalls, equals(1));

      baseApiClient.formatError(
        Response(statusCode: 401, requestOptions: RequestOptions(path: "/api")),
      );

      expect(await authRepository.validateSession(), isTrue);
      expect(memberCalls, equals(2));
    });

    test("repeated validations hit the members endpoint only once", () async {
      expect(await authRepository.validateSession(), isTrue);
      expect(await authRepository.validateSession(), isTrue);
      expect(await authRepository.validateSession(), isTrue);

      expect(memberCalls, equals(1));
      verify(() => membersRepository.getByUuidAsync("user-uuid")).called(1);
    });

    test("the cached member is reused by the callers", () async {
      expect(await authRepository.validateSession(), isTrue);

      expect(authRepository.currentMember, equals(member));
    });

    test("a failed validation is not retried over the network", () async {
      when(() => membersRepository.getByUuidAsync(any())).thenAnswer((_) async {
        memberCalls++;
        return Failure(Exception("Member not found"));
      });

      expect(await authRepository.validateSession(), isFalse);
      // The failure cleared the stored uuid, so the second call answers from
      // the cache instead of hitting the network again.
      expect(await authRepository.validateSession(), isFalse);

      expect(memberCalls, equals(1));
    });

    test("logout invalidates the cached session", () async {
      expect(await authRepository.validateSession(), isTrue);

      final result = await authRepository.logout();
      expect(result.isSuccess(), isTrue);

      // The cached validity did not survive the logout, and answering it
      // does not need the network.
      expect(await authRepository.validateSession(), isFalse);
      expect(memberCalls, equals(1));
    });

    test("a new login validates the session over the network again", () async {
      expect(await authRepository.validateSession(), isTrue);

      await authRepository.logout();

      when(() => authApiClient.loginAsync(any(), any())).thenAnswer(
        (_) async => Success(
          LoginResponse(accessToken: "new-token", userId: "new-uuid"),
        ),
      );
      final loginResult = await authRepository.login(
        email: "ana@test.com",
        password: "password123",
      );
      expect(loginResult.isSuccess(), isTrue);

      expect(await authRepository.validateSession(), isTrue);
      expect(memberCalls, equals(2));
      verify(() => membersRepository.getByUuidAsync("new-uuid")).called(1);
    });
  });
}

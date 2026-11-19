import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart"
    show ApiV1AuthLoginPost$RequestBody, LoginResponse;
import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/google_sign_in_service.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
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
  late MockIMembersRepository mockMembersRepository;
  late MockAuthApiClient mockAuthApiClient;
  late MockGoogleSignInService mockGoogleSignInService;
  late MockSecureStorageService mockSecureStorageService;

  setUpAll(() {
    // Register fallback value for LoginRequest (sealed freezed class)
    registerFallbackValue(
      ApiV1AuthLoginPost$RequestBody(
        email: "fallback@test.com",
        password: "fallback",
      ),
    );
  });

  setUp(() {
    mockMembersRepository = MockIMembersRepository();
    mockAuthApiClient = MockAuthApiClient();
    mockGoogleSignInService = MockGoogleSignInService();
    mockSecureStorageService = MockSecureStorageService();
    when(
      () => mockSecureStorageService.saveRefreshToken(any()),
    ).thenAnswer((_) async => const Success(true));
    final mockBaseApiClient = MockIBaseApiClient();

    authRepository = AuthRepository(
      membersRepository: mockMembersRepository,
      authApiClient: mockAuthApiClient,
      googleSignInService: mockGoogleSignInService,
      baseApiClient: mockBaseApiClient,
      sharedPreferencesService: mockSecureStorageService,
      authListenable: AuthListenable(),
    );
  });

  group("currentUuid single-flight", () {
    test("concurrent calls share the same in-flight Future", () async {
      // Arrange: Set up successful SharedPreferences reads
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("test-token"));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => const Success("test-uuid"));

      // Act: Call currentUuid concurrently multiple times
      final future1 = authRepository.currentUuid;
      final future2 = authRepository.currentUuid;
      final future3 = authRepository.currentUuid;

      final results = await Future.wait([future1, future2, future3]);

      // Assert: All concurrent calls return the same UUID
      for (final uuid in results) {
        expect(uuid, equals("test-uuid"));
      }

      // Verify the SharedPreferences was only called once per type
      verify(() => mockSecureStorageService.fetchToken()).called(1);
      verify(() => mockSecureStorageService.fetchUuid()).called(1);
    });

    test("login clears the UUID cache", () async {
      // Arrange: Set up initial state with null values
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success(""));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => Failure(Exception("UUID not found")));

      // Prime the cache with null values
      await authRepository.currentUuid;

      // Act: Login with new credentials
      final loginResponse = LoginResponse(
        accessToken: "new-token",
        userId: "new-uuid",
      );

      when(
        () => mockAuthApiClient.loginAsync(any(), any()),
      ).thenAnswer((_) async => Success(loginResponse));
      when(
        () => mockSecureStorageService.saveUuid(any()),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSecureStorageService.saveToken(any()),
      ).thenAnswer((_) async => const Success(true));

      await authRepository.login(
        email: "test@example.com",
        password: "password123",
      );
      verify(() => mockSecureStorageService.saveToken("new-token")).called(1);

      // Act: Simulate fresh SharedPreferences after login and re-fetch
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("new-token"));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => const Success("new-uuid"));

      final uuid = await authRepository.currentUuid;

      // Assert: New UUID is returned
      expect(uuid, equals("new-uuid"));
    });
    test("logout clears the persisted token", () async {
      // Arrange
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("access-token"));
      when(
        () => mockSecureStorageService.saveUuid(any()),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSecureStorageService.saveToken(any()),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockAuthApiClient.logout("access-token"),
      ).thenAnswer((_) async => Success.unit());

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(() => mockSecureStorageService.saveToken(null)).called(1);
      verify(() => mockAuthApiClient.logout("access-token")).called(1);
    });

    test("refresh persists the new access token", () async {
      // Arrange
      final response = LoginResponse(
        accessToken: "refreshed-access-token",
        refreshToken: "refreshed-refresh-token",
        userId: "user-id",
      );
      when(
        () => mockAuthApiClient.refresh("refresh-token"),
      ).thenAnswer((_) async => Success(response));
      when(
        () => mockSecureStorageService.saveUuid("user-id"),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSecureStorageService.saveToken("refreshed-access-token"),
      ).thenAnswer((_) async => const Success(true));

      // Act
      final result = await authRepository.refresh("refresh-token");

      // Assert
      expect(result.getOrNull(), equals(response));
      verify(
        () => mockSecureStorageService.saveToken("refreshed-access-token"),
      ).called(1);
      verify(
        () => mockSecureStorageService.saveRefreshToken(
          "refreshed-refresh-token",
        ),
      ).called(1);
    });
  });
}

import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";
import "package:test/test.dart";

class MockIMembersRepository extends Mock implements IMembersRepository {}

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockSecureStorageService extends Mock
    implements SecureStorageService {}

class MockIBaseApiClient extends Mock implements IBaseApiClient {
  @override
  late Dio client;
}

void main() {
  late AuthRepository authRepository;
  late MockIMembersRepository mockMembersRepository;
  late MockAuthApiClient mockAuthApiClient;
  late MockSecureStorageService mockSecureStorageService;

  setUpAll(() {
    // Register fallback value for LoginRequest (sealed freezed class)
    registerFallbackValue(
      LoginRequest(email: "fallback@test.com", password: "fallback"),
    );
  });

  setUp(() {
    mockMembersRepository = MockIMembersRepository();
    mockAuthApiClient = MockAuthApiClient();
    mockSecureStorageService = MockSecureStorageService();
    final mockBaseApiClient = MockIBaseApiClient();

    authRepository = AuthRepository(
      membersRepository: mockMembersRepository,
      authApiClient: mockAuthApiClient,
      baseApiClient: mockBaseApiClient,
      sharedPreferencesService: mockSecureStorageService,
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

    test("logout clears the UUID cache", () async {
      // Arrange: Set up a logged-in state with cached UUID
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("test-token"));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => const Success("test-uuid"));

      // Prime the cache
      final cachedUuid = await authRepository.currentUuid;
      expect(cachedUuid, equals("test-uuid"));

      // Setup logout to clear cache
      when(
        () => mockSecureStorageService.saveUuid(any()),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSecureStorageService.saveToken(any()),
      ).thenAnswer((_) async => const Success(true));

      await authRepository.logout();

      // Act: Fetch UUID again after logout - should be null
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success(""));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => Failure(Exception("UUID not found")));

      final uuidAfterLogout = await authRepository.currentUuid;

      // Assert: UUID cache was cleared, re-fetches as null
      expect(uuidAfterLogout, isNull);
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
        () => mockAuthApiClient.logIn(any()),
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
  });
}

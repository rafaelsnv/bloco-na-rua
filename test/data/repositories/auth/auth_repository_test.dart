import "package:bloco_na_rua/data/repositories/auth/auth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart";
import "package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart";
import "package:bloco_na_rua/data/services/shared_preferencies_service.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";
import "package:test/test.dart";

class MockIMembersRepository extends Mock implements IMembersRepository {}

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

void main() {
  late AuthRepository authRepository;
  late MockIMembersRepository mockMembersRepository;
  late MockAuthApiClient mockAuthApiClient;
  late MockSharedPreferencesService mockSharedPreferencesService;

  setUpAll(() {
    // Register fallback value for LoginRequest (sealed freezed class)
    registerFallbackValue(
      LoginRequest(email: "fallback@test.com", password: "fallback"),
    );
  });

  setUp(() {
    mockMembersRepository = MockIMembersRepository();
    mockAuthApiClient = MockAuthApiClient();
    mockSharedPreferencesService = MockSharedPreferencesService();

    authRepository = AuthRepository(
      membersRepository: mockMembersRepository,
      authApiClient: mockAuthApiClient,
      sharedPreferencesService: mockSharedPreferencesService,
    );
  });

  group("currentUuid single-flight", () {
    test("concurrent calls share the same in-flight Future", () async {
      // Arrange: Set up successful SharedPreferences reads
      when(
        () => mockSharedPreferencesService.fetchToken(),
      ).thenAnswer((_) async => const Success("test-token"));
      when(
        () => mockSharedPreferencesService.fetchUuid(),
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
      verify(() => mockSharedPreferencesService.fetchToken()).called(1);
      verify(() => mockSharedPreferencesService.fetchUuid()).called(1);
    });

    test("logout clears the UUID cache", () async {
      // Arrange: Set up a logged-in state with cached UUID
      when(
        () => mockSharedPreferencesService.fetchToken(),
      ).thenAnswer((_) async => const Success("test-token"));
      when(
        () => mockSharedPreferencesService.fetchUuid(),
      ).thenAnswer((_) async => const Success("test-uuid"));

      // Prime the cache
      final cachedUuid = await authRepository.currentUuid;
      expect(cachedUuid, equals("test-uuid"));

      // Setup logout to clear cache
      when(
        () => mockSharedPreferencesService.saveUuid(any()),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSharedPreferencesService.saveToken(any()),
      ).thenAnswer((_) async => const Success(true));

      await authRepository.logout();

      // Act: Fetch UUID again after logout - should be null
      when(
        () => mockSharedPreferencesService.fetchToken(),
      ).thenAnswer((_) async => const Success(""));
      when(
        () => mockSharedPreferencesService.fetchUuid(),
      ).thenAnswer((_) async => Failure(Exception("UUID not found")));

      final uuidAfterLogout = await authRepository.currentUuid;

      // Assert: UUID cache was cleared, re-fetches as null
      expect(uuidAfterLogout, isNull);
    });

    test("login clears the UUID cache", () async {
      // Arrange: Set up initial state with null values
      when(
        () => mockSharedPreferencesService.fetchToken(),
      ).thenAnswer((_) async => const Success(""));
      when(
        () => mockSharedPreferencesService.fetchUuid(),
      ).thenAnswer((_) async => Failure(Exception("UUID not found")));

      // Prime the cache with null values
      await authRepository.currentUuid;

      // Act: Login with new credentials
      final loginResponse = LoginResponse(
        accessToken: "new-token",
        userUuid: "new-uuid",
      );

      when(
        () => mockAuthApiClient.logIn(any()),
      ).thenAnswer((_) async => Success(loginResponse));
      when(
        () => mockSharedPreferencesService.saveUuid(any()),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSharedPreferencesService.saveToken(any()),
      ).thenAnswer((_) async => const Success(true));

      await authRepository.login(
        email: "test@example.com",
        password: "password123",
      );

      // Act: Simulate fresh SharedPreferences after login and re-fetch
      when(
        () => mockSharedPreferencesService.fetchToken(),
      ).thenAnswer((_) async => const Success("new-token"));
      when(
        () => mockSharedPreferencesService.fetchUuid(),
      ).thenAnswer((_) async => const Success("new-uuid"));

      final uuid = await authRepository.currentUuid;

      // Assert: New UUID is returned
      expect(uuid, equals("new-uuid"));
    });
  });
}

import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart" show ApiV1AuthLoginPost$RequestBody, LoginResponse, MemberCreate;
import "package:bloco_na_rua/data/repositories/auth/auth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";
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

  setUpAll(() async {
    // Mock the SharedPreferences plugin before initializing Supabase — Supabase
    // uses it internally for session storage and would throw MissingPluginException
    // otherwise. We never persist anything meaningful (fake URL, no session).
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // Initialize Supabase once so `Supabase.instance.client.auth` is accessible.
    // logout() and the signUp cleanup path call into it; we never hit a real
    // server (fake URL, no session) so this is hermetic.
    await Supabase.initialize(
      url: "http://localhost:54321",
      // ponytail: publishableKey not yet available in supabase_flutter 2.10.0
      anonKey: "fake-anon-key-for-tests", // ignore: deprecated_member_use
    );

    // Register fallback values for freezed/sealed types used as parameters.
    registerFallbackValue(
      ApiV1AuthLoginPost$RequestBody(email: "fallback@test.com", password: "fallback"),
    );
    registerFallbackValue(
      const SignUpRequest(
        name: "fallback",
        email: "fallback@test.com",
        phone: "000000000",
        password: "fallback",
      ),
    );
    registerFallbackValue(
      MemberCreate(
        uuid: "fallback-uuid",
        name: "fallback",
        email: "fallback@test.com",
        phone: "000000000",
      ),
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

  group("validateSession", () {
    test("returns true and caches member when member found by uuid", () async {
      // Arrange
      const uuid = "valid-uuid-123";
      final member = MembersEntity(id: 1, name: "Jane Doe", uuid: uuid);

      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("test-token"));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => const Success(uuid));
      when(
        () => mockMembersRepository.getByUuidAsync(uuid),
      ).thenAnswer((_) async => Success(member));

      // Act
      final result = await authRepository.validateSession();

      // Assert
      expect(result, isTrue);
      expect(authRepository.currentMember, equals(member));
      expect(await authRepository.isAuthenticated, isTrue);
    });

    test("returns false when uuid is null", () async {
      // Arrange
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("test-token"));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => Failure(Exception("UUID not found")));

      // Act
      final result = await authRepository.validateSession();

      // Assert
      expect(result, isFalse);
      verifyNever(() => mockMembersRepository.getByUuidAsync(any()));
    });

    test("returns false and clears stale state when member not found", () async {
      // Arrange
      const uuid = "stale-uuid";
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => const Success("stale-token"));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => const Success(uuid));
      when(
        () => mockMembersRepository.getByUuidAsync(uuid),
      ).thenAnswer((_) async => Failure(Exception("Member not found")));
      when(
        () => mockSecureStorageService.saveUuid(null),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSecureStorageService.saveToken(null),
      ).thenAnswer((_) async => const Success(true));

      // Act
      final result = await authRepository.validateSession();

      // Assert
      expect(result, isFalse);
      verify(() => mockSecureStorageService.saveUuid(null)).called(1);
      verify(() => mockSecureStorageService.saveToken(null)).called(1);
      expect(authRepository.currentMember, isNull);
    });
  });

  group("signUp", () {
    const signUpRequest = SignUpRequest(
      name: "John Doe",
      email: "john@example.com",
      phone: "123456789",
      password: "password123",
    );

    test("returns Success and sets auth state when auth + member registration succeed",
        () async {
      // Arrange
      const userId = "user-uuid-456";
      final loginResponse = LoginResponse(
        userId: userId,
        accessToken: "access-token",
      );
      final member = MembersEntity(id: 1, name: "John Doe", uuid: userId);

      when(
        () => mockAuthApiClient.signUp(any()),
      ).thenAnswer((_) async => Success(loginResponse));
      when(
        () => mockMembersRepository.createAsync(any()),
      ).thenAnswer((_) async => Success(member));
      when(
        () => mockSecureStorageService.saveUuid(any()),
      ).thenAnswer((_) async => const Success(true));

      // Act
      final result = await authRepository.signUp(signUpRequest);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull()?.userId, equals(userId));
      expect(await authRepository.isAuthenticated, isTrue);
      verify(() => mockAuthApiClient.signUp(signUpRequest)).called(1);
      verify(() => mockMembersRepository.createAsync(any())).called(1);
      verify(() => mockSecureStorageService.saveUuid(userId)).called(1);
    });

    test("returns Failure when AuthApiClient.signUp fails", () async {
      // Arrange
      when(
        () => mockAuthApiClient.signUp(any()),
      ).thenAnswer((_) async => Failure(Exception("Auth failed")));

      // Act
      final result = await authRepository.signUp(signUpRequest);

      // Assert
      expect(result.isError(), isTrue);
      verifyNever(() => mockMembersRepository.createAsync(any()));
      verifyNever(() => mockSecureStorageService.saveUuid(any()));
    });

    test("returns Failure when member registration fails", () async {
      // Arrange
      const userId = "user-uuid-456";
      final loginResponse = LoginResponse(
        userId: userId,
        accessToken: "access-token",
      );
      when(
        () => mockAuthApiClient.signUp(any()),
      ).thenAnswer((_) async => Success(loginResponse));
      when(
        () => mockMembersRepository.createAsync(any()),
      ).thenAnswer(
        (_) async => Failure(Exception("Member creation failed")),
      );
      when(
        () => mockSecureStorageService.saveToken(null),
      ).thenAnswer((_) async => const Success(true));
      // `isAuthenticated` is checked below — it lazily fetches uuid+token
      // on first access. Stub them so the assertion has deterministic state.
      when(
        () => mockSecureStorageService.fetchToken(),
      ).thenAnswer((_) async => Failure(Exception("Token not found")));
      when(
        () => mockSecureStorageService.fetchUuid(),
      ).thenAnswer((_) async => Failure(Exception("UUID not found")));

      // Act
      final result = await authRepository.signUp(signUpRequest);

      // Assert
      expect(result.isError(), isTrue);
      // _isAuthenticated must NOT be set when member registration failed
      expect(await authRepository.isAuthenticated, isFalse);
    });
  });

  group("logout", () {
    test("returns Success.unit() and clears local auth state", () async {
      // Arrange
      when(
        () => mockSecureStorageService.saveUuid(null),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => mockSecureStorageService.saveToken(null),
      ).thenAnswer((_) async => const Success(true));

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(await authRepository.isAuthenticated, isFalse);
      expect(authRepository.currentMember, isNull);
      verify(() => mockSecureStorageService.saveUuid(null)).called(1);
      verify(() => mockSecureStorageService.saveToken(null)).called(1);
    });

    test("returns Success even when storage clear fails (logged, not raised)",
        () async {
      // Arrange: cleanup failures are logged but don't change the outcome
      when(
        () => mockSecureStorageService.saveUuid(null),
      ).thenAnswer((_) async => Failure(Exception("Storage error")));
      when(
        () => mockSecureStorageService.saveToken(null),
      ).thenAnswer((_) async => Failure(Exception("Storage error")));

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(await authRepository.isAuthenticated, isFalse);
    });
  });

  group("resetPassword", () {
    test("returns Success.unit() when api succeeds", () async {
      // Arrange
      when(
        () => mockAuthApiClient.resetPassword("user@example.com"),
      ).thenAnswer((_) async => Success.unit());

      // Act
      final result = await authRepository.resetPassword("user@example.com");

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(() => mockAuthApiClient.resetPassword("user@example.com")).called(1);
    });

    test("returns Failure when api fails", () async {
      // Arrange
      when(
        () => mockAuthApiClient.resetPassword("user@example.com"),
      ).thenAnswer((_) async => Failure(Exception("Network error")));

      // Act
      final result = await authRepository.resetPassword("user@example.com");

      // Assert
      expect(result.isError(), isTrue);
    });
  });

  group("resendVerification", () {
    test("returns Success.unit() when api succeeds", () async {
      // Arrange
      when(
        () => mockAuthApiClient.resendVerification("user@example.com"),
      ).thenAnswer((_) async => Success.unit());

      // Act
      final result = await authRepository.resendVerification("user@example.com");

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(
        () => mockAuthApiClient.resendVerification("user@example.com"),
      ).called(1);
    });

    test("returns Failure when api fails", () async {
      // Arrange
      when(
        () => mockAuthApiClient.resendVerification("user@example.com"),
      ).thenAnswer((_) async => Failure(Exception("Network error")));

      // Act
      final result = await authRepository.resendVerification("user@example.com");

      // Assert
      expect(result.isError(), isTrue);
    });
  });
}
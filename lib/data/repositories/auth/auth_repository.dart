import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/data/services/api/members/create/member_create.dart";
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart";
import "package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:dio/dio.dart";
import "package:logging/logging.dart";
import "package:result_dart/result_dart.dart";

class AuthRepository implements IAuthRepository {
  AuthRepository({
    required IMembersRepository membersRepository,
    required AuthApiClient authApiClient,
    required IBaseApiClient baseApiClient,
    required SecureStorageService sharedPreferencesService,
  }) : _membersRepository = membersRepository,
       _authApiClient = authApiClient,
       _baseApiClient = baseApiClient,
       _secureStorageService = sharedPreferencesService;

  final IMembersRepository _membersRepository;
  final AuthApiClient _authApiClient;
  final IBaseApiClient _baseApiClient;
  final SecureStorageService _secureStorageService;

  bool? _isAuthenticated;
  String? _authToken;
  MembersEntity? _currentMember;

  /// In-flight cache: if `currentUuid` is called concurrently, all callers
  /// share the same `Future<String?>` instead of each triggering their own
  /// `_fetchTokenAndUuid` (which would fire duplicate SharedPreferences reads).
  Future<String?>? _currentUuidFuture;

  final _log = Logger("AuthRepository");

  Future<String?> _fetchTokenAndUuid() async {
    final tokenResult = await _secureStorageService.fetchToken();
    if (tokenResult.isError()) {
      _log.severe("Failed to fetch Token from SharedPreferences");
      _authToken = null;
    } else {
      _authToken = tokenResult.getOrNull();
    }

    final uuidResult = await _secureStorageService.fetchUuid();
    if (uuidResult.isError()) {
      _log.severe("Failed to fetch User ID from SharedPreferences");
    }

    final uuid = uuidResult.getOrNull();
    _isAuthenticated = _authToken != null && uuid != null;
    return uuid;
  }

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // Ensure `currentUuid` has been resolved at least once.
    await currentUuid;
    return _isAuthenticated ?? false;
  }

  @override
  Future<String?> get currentUuid async {
    if (_currentUuidFuture != null) {
      return _currentUuidFuture!;
    }
    _currentUuidFuture = _fetchTokenAndUuid();
    return _currentUuidFuture!;
  }

  @override
  MembersEntity? get currentMember => _currentMember;

  @override
  void setCurrentMember(MembersEntity member) {
    _currentMember = member;
  }

  @override
  Future<bool> validateSession() async {
    final uuid = await currentUuid;
    if (uuid == null || uuid.isEmpty) {
      return false;
    }

    final memberResult = await _membersRepository.getByUuidAsync(uuid);
    if (memberResult.isError()) {
      _log.warning(
        "Session validation failed: member not found for uuid: $uuid",
      );
      // Clear stale data
      await _secureStorageService.saveUuid(null);
      await _secureStorageService.saveToken(null);
      _currentUuidFuture = null;
      _authToken = null;
      _currentMember = null;
      _isAuthenticated = false;
      return false;
    }

    // Cache member so subsequent callers (HomeCubit, ProfileCubit, etc.)
    // can avoid duplicate GET /Members/uuid/{uuid} requests.
    _currentMember = memberResult.getOrNull();
    return true;
  }

  @override
  AsyncResult<LoginResponse> login({
    required String email,
    required String password,
    String? phone = "",
  }) async {
    final loginRequest = LoginRequest(email: email, password: password);

    final loginResult = await _authApiClient.logIn(loginRequest);

    if (loginResult.isError()) {
      _log.severe("Failed to login", loginResult.exceptionOrNull());
      return loginResult;
    }

    final loginResponse = loginResult.getOrNull();
    if (loginResponse == null) {
      _log.warning("Login response is null");
      return loginResult;
    }

    _log.info("Login successful");
    _isAuthenticated = true;
    _authToken = loginResponse.accessToken;
    // Invalidate the in-flight future so the next `currentUuid` call
    // re-fetches from SharedPreferences (now updated with the new token/uuid).
    _currentUuidFuture = null;
    // Invalidate cached member; the next call to validateSession()
    // or GetCurrentUserData will refresh it. We don't fetch here to
    // avoid a redundant request when the router redirect already
    // calls validateSession() in the same frame.
    _currentMember = null;

    var userIdResult = await _secureStorageService.saveUuid(
      loginResponse.userId,
    );
    if (userIdResult.isError()) {
      _log.severe("Failed to save User UUID", userIdResult.exceptionOrNull());
    }

    var tokenResult = await _secureStorageService.saveToken(
      loginResponse.accessToken,
    );
    if (tokenResult.isError()) {
      _log.warning("Failed to login", loginResult.exceptionOrNull());
      return Failure(tokenResult.exceptionOrNull()!);
    }

    return loginResult;
  }

  @override
  AsyncResult<LoginResponse> signUp(SignUpRequest signUpRequest) async {
    final authResult = await _authApiClient.signUp(signUpRequest);
    if (authResult.isError() || authResult.getOrNull() == null) {
      _log.severe(
        "Failed to sign up",
        authResult.exceptionOrNull() ?? authResult.getOrNull(),
      );

      return authResult;
    }

    var userData = authResult.getOrNull();
    if (userData == null) {
      return Failure(Exception("User data is null"));
    }

    var membersResult = await _registerMember(signUpRequest, userData.userId);
    if (membersResult.isError()) {
      // Clean up Supabase auth user via backend endpoint if member creation failed
      await _signupCleanup(userData.userId);
      return Failure(membersResult.exceptionOrNull()!);
    }

    _log.info("Sign up successful");
    // Only set authenticated AFTER member registration succeeded
    _isAuthenticated = true;
    _authToken = userData.accessToken;
    // Invalidate the in-flight future; next `currentUuid` call re-fetches.
    _currentUuidFuture = null;
    // Invalidate cached member; GetCurrentUserData will fetch it.
    _currentMember = null;

    var userIdResult = await _secureStorageService.saveUuid(
      userData.userId,
    );
    if (userIdResult.isError()) {
      _log.severe("Failed to save User ID", userIdResult.exceptionOrNull());
      // Clean up - don't keep authenticated state without persistence
      _isAuthenticated = false;
      _authToken = null;
      _currentUuidFuture = null;
      await _secureStorageService.saveUuid(null);
      return Failure(Exception("Failed to persist session"));
    }

    var tokenResult = await _secureStorageService.saveToken(
      userData.accessToken,
    );
    if (tokenResult.isError()) {
      _log.severe("Failed to save token", tokenResult.exceptionOrNull());
      // Clean up - don't keep authenticated state without persistence
      _isAuthenticated = false;
      _authToken = null;
      _currentUuidFuture = null;
      await _secureStorageService.saveUuid(null); // Clear uuid too
      return Failure(Exception("Failed to persist session"));
    }
    _log.info("Token saved successfully");
    return authResult;
  }

  @override
  AsyncResult<void> logout() async {
    _log.info("Logging out");

    // Clear local auth state first so concurrent callers immediately see the
    // logged-out state, even if SharedPreferences cleanup fails.
    _authToken = null;
    _currentUuidFuture = null;
    _currentMember = null;
    _isAuthenticated = false;

    final userIdResult = await _secureStorageService.saveUuid(null);
    if (userIdResult.isError()) {
      _log.warning(
        "Failed to clear stored User ID",
        userIdResult.exceptionOrNull(),
      );
    }

    final tokenResult = await _secureStorageService.saveToken(null);
    if (tokenResult.isError()) {
      _log.warning(
        "Failed to clear stored auth token",
        tokenResult.exceptionOrNull(),
      );
    }

    // Logout succeeded as far as the user is concerned; cleanup failures
    // are logged but do not change the outcome.
    return Success.unit();
  }

  @override
  AsyncResult<void> resetPassword(String email) async {
    final result = await _authApiClient.resetPassword(email);
    if (result.isError()) {
      _log.severe("Failed to reset password");
      return result;
    }

    _log.info("Password reset email sent");
    return result;
  }

  @override
  AsyncResult<void> resendVerification(String email) async {
    final result = await _authApiClient.resendVerification(email);
    if (result.isError()) {
      _log.severe("Failed to resend verification email");
      return result;
    }

    _log.info("Verification email resent");
    return result;
  }

  AsyncResult<MembersEntity> _registerMember(
    SignUpRequest signUpData,
    String uuid,
  ) async {
    final model = MemberCreate(
      uuid: uuid,
      name: signUpData.name,
      email: signUpData.email,
      phone: signUpData.phone,
    );
    _log.info("Registering member");
    var membersResult = await _membersRepository.createAsync(model);
    if (membersResult.isError() || membersResult.getOrNull() == null) {
      _log.severe(
        "Failed to register member",
        membersResult.exceptionOrNull() ?? membersResult.getOrNull(),
      );
      await _signupCleanup(model.uuid);
      await _secureStorageService.saveToken(null);
      return Failure(membersResult.exceptionOrNull()!);
    }
    _log.info("Member registered successfully");
    return membersResult;
  }

  Future<void> _signupCleanup(String uuid) async {
    try {
      // Use the stored token if available, otherwise try to fetch it
      final token = _authToken ?? (await _secureStorageService.fetchToken()).getOrNull();
      if (token == null) {
        _log.warning("No token available for signup cleanup");
        return;
      }
      await _baseApiClient.client.delete(
        '/api/v1/admin/signup-cleanup/$uuid',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      _log.severe("Signup cleanup failed", e);
    }
  }
}

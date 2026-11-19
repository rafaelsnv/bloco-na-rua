import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart"
    show ApiV1AuthLoginPost$RequestBody, LoginResponse, MemberCreate;
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:dio/dio.dart";
import "package:logging/logging.dart";
import "package:result_dart/result_dart.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class AuthRepository implements IAuthRepository {
  AuthRepository({
    required IMembersRepository membersRepository,
    required AuthApiClient authApiClient,
    required IBaseApiClient baseApiClient,
    required SecureStorageService sharedPreferencesService,
    required AuthListenable authListenable,
  }) : _membersRepository = membersRepository,
       _authApiClient = authApiClient,
       _baseApiClient = baseApiClient,
       _secureStorageService = sharedPreferencesService,
       _authListenable = authListenable {
    // The API layer is the only place that sees the backend rejecting the
    // session (401). It calls back into the repository so the cached
    // validity is dropped and the router re-evaluates the guarded routes.
    _baseApiClient.onSessionRevoked = _onSessionRevoked;
  }

  final IMembersRepository _membersRepository;
  final AuthApiClient _authApiClient;
  final IBaseApiClient _baseApiClient;
  final SecureStorageService _secureStorageService;
  final AuthListenable _authListenable;

  bool? _isAuthenticated;
  String? _authToken;
  MembersEntity? _currentMember;

  /// Cached session validity. Null = "not validated yet", so the next
  /// [validateSession] hits the network; true/false = answer served from
  /// cache.
  ///
  /// The router redirect asks for the session on every navigation, and each
  /// validation is a `GET /Members/uuid/{uuid}` round trip. The cache is
  /// dropped whenever the auth state changes (login, sign-up, logout), when a
  /// validation fails, or when the backend revokes the session (401), so a
  /// real auth change is always picked up.
  bool? _sessionValid;

  /// In-flight cache: if `currentUuid` is called concurrently, all callers
  /// share the same `Future<String?>` instead of each triggering their own
  /// `_fetchTokenAndUuid` (which would fire duplicate SharedPreferences reads).
  Future<String?>? _currentUuidFuture;

  /// In-flight cache: concurrent [validateSession] callers share the same
  /// `Future<bool>` instead of each firing its own
  /// `GET /Members/uuid/{uuid}` request. Mirrors the [_currentUuidFuture]
  /// pattern.
  Future<bool>? _validateSessionFuture;

  /// Incremented every time the cached session validity is dropped.
  ///
  /// A validation that started before the drop must not write its (stale)
  /// answer back into the cache — otherwise a revoked session would look
  /// valid again.
  int _sessionEpoch = 0;

  final _log = Logger("AuthRepository");

  Future<String?> _fetchTokenAndUuid() async {
    final tokenResult = await _secureStorageService.fetchToken();
    // design: storage layer wraps absence as Failure for symmetry, but a
    // missing token/UUID on first launch is not an error — log at INFO and
    // treat the user as unauthenticated.
    if (tokenResult.isError()) {
      _log.info("Token not found (first launch or cleared)");
      _authToken = null;
    } else {
      _authToken = tokenResult.getOrNull();
    }

    final uuidResult = await _secureStorageService.fetchUuid();
    if (uuidResult.isError()) {
      _log.info("User ID not found (first launch or cleared)");
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
    // design: defer to next microtask so the storage read happens after the
    // current frame is built (no startup frame blocking).
    _currentUuidFuture = Future.microtask(_fetchTokenAndUuid);
    return _currentUuidFuture!;
  }

  @override
  MembersEntity? get currentMember => _currentMember;

  @override
  void setCurrentMember(MembersEntity member) {
    _currentMember = member;
  }

  @override
  Future<bool> validateSession() {
    // Serve the cached answer when we have one: this is the path the router
    // redirect takes on every navigation, and it must not hit the network.
    final cached = _sessionValid;
    if (cached != null) {
      return Future.value(cached);
    }
    // Share the in-flight validation: at startup the redirect and the
    // auth-listenable refresh can fire together, and both must not hit the
    // members endpoint.
    final inFlight = _validateSessionFuture;
    if (inFlight != null) {
      return inFlight;
    }
    final future = _validateSession();
    _validateSessionFuture = future;
    // Release the slot when the validation settles. The error is handled
    // here so it is never reported as unhandled; the caller still sees it.
    future.then<void>(
      (_) => _releaseValidateSessionFuture(future),
      onError: (Object _, StackTrace stackTrace) =>
          _releaseValidateSessionFuture(future),
    );
    return future;
  }

  void _releaseValidateSessionFuture(Future<bool> future) {
    if (identical(_validateSessionFuture, future)) {
      _validateSessionFuture = null;
    }
  }

  /// Drops the cached session validity and announces the revocation.
  ///
  /// Called by the data layer when the backend rejects the session (401):
  /// the cached `true` must not survive a revoked session, and the router
  /// has to re-evaluate the guarded routes. The next [validateSession]
  /// checks the session against the backend again.
  @override
  void invalidateSession() {
    final wasValid = _sessionValid == true;
    // Bump the epoch: a validation that is already in flight must not write
    // its (stale) answer back into the cache.
    _sessionEpoch++;
    _sessionValid = null;
    _validateSessionFuture = null;
    if (wasValid) {
      _authListenable.notify();
    }
  }

  void _onSessionRevoked(ApiError error) {
    _log.warning("Session revoked by the backend: ${error.statusCode}");
    invalidateSession();
  }

  Future<bool> _validateSession() async {
    final epoch = _sessionEpoch;
    final uuid = await currentUuid;
    if (uuid == null || uuid.isEmpty) {
      _sessionValid = false;
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
      _sessionValid = false;
      return false;
    }

    // A revocation may have happened while this request was in flight.
    if (epoch != _sessionEpoch) {
      return false;
    }

    // Cache member so subsequent callers (HomeCubit, ProfileCubit, etc.)
    // can avoid duplicate GET /Members/uuid/{uuid} requests.
    _currentMember = memberResult.getOrNull();
    _sessionValid = true;
    return true;
  }

  @override
  AsyncResult<LoginResponse> login({
    required String email,
    required String password,
    String? phone = "",
  }) async {
    final loginRequest = ApiV1AuthLoginPost$RequestBody(
      email: email,
      password: password,
    );

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

    // Save UUID first — only set auth state after this succeeds.
    // If saveUuid fails, we sign out to avoid inconsistent state where
    // _authToken is set but _currentMember/_isAuthenticated are not.
    var userIdResult = await _secureStorageService.saveUuid(
      loginResponse.userId,
    );
    if (userIdResult.isError()) {
      _log.severe("Failed to save User UUID", userIdResult.exceptionOrNull());
      await Supabase.instance.client.auth.signOut();
      return Failure(userIdResult.exceptionOrNull()!);
    }

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
    // The session changed: drop the cached validity so the next validation
    // re-checks it against the backend (and refreshes the cached member).
    _sessionValid = null;
    _validateSessionFuture = null;

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

    final userId = userData.userId;
    if (userId == null) {
      return Failure(Exception("User ID is null"));
    }

    var membersResult = await _registerMember(signUpRequest, userId);
    if (membersResult.isError()) {
      // Clean up Supabase auth user via backend endpoint if member creation failed
      final cleanupError = await _signupCleanup(userId);
      if (cleanupError.isError()) {
        // Log but don't crash — fire-and-forget with server-side reconciliation.
        // Backend TO-DO: scheduled orphan-cleanup cron to catch missed cleanups.
        _log.severe(
          'Orphan Supabase user $userId: member registration failed and cleanup also failed',
          cleanupError.exceptionOrNull(),
        );
      }
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
    // The session changed: drop the cached validity so the next validation
    // re-checks it against the backend.
    _sessionValid = null;
    _validateSessionFuture = null;

    var userIdResult = await _secureStorageService.saveUuid(userData.userId);
    if (userIdResult.isError()) {
      _log.severe("Failed to save User ID", userIdResult.exceptionOrNull());
    }

    return authResult;
  }

  @override
  AsyncResult<void> logout() async {
    _log.info("Logging out");

    // Clear Supabase session (handles token cleanup and refresh).
    // A sign-out failure must never block the local cleanup below — the user
    // has to end up logged out either way.
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      _log.warning("Supabase sign-out failed; continuing local logout", e);
    }

    // Clear local auth state
    _authToken = null;
    _currentUuidFuture = null;
    _currentMember = null;
    _isAuthenticated = false;
    // The session is gone: the cached validity must not survive the logout.
    _sessionValid = false;
    _validateSessionFuture = null;

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
      // Backend requires the field despite swagger marking it nullable (TKT-003).
      profileImage: '',
    );
    _log.info("Registering member");
    var membersResult = await _membersRepository.createAsync(model);
    if (membersResult.isError() || membersResult.getOrNull() == null) {
      _log.severe(
        "Failed to register member",
        membersResult.exceptionOrNull() ?? membersResult.getOrNull(),
      );
      await _signupCleanup(model.uuid!);
      await _secureStorageService.saveToken(null);
      return Failure(membersResult.exceptionOrNull()!);
    }
    _log.info("Member registered successfully");
    return membersResult;
  }

  Future<Result<void>> _signupCleanup(String uuid) async {
    try {
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token == null) {
        _log.warning("No token available for signup cleanup");
        return Success.unit();
      }
      await _baseApiClient.client.delete(
        '/api/v1/admin/signup-cleanup/$uuid',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Success.unit();
    } catch (e) {
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}

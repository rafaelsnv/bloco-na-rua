import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/data/services/api/base/ibase_api_client.dart";
import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart"
    show LoginResponse;
import "package:bloco_na_rua/data/services/auth/auth_api_client.dart";
import "package:bloco_na_rua/data/services/auth/google_sign_in_service.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/data/services/secure_storage_service.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:logging/logging.dart";
import "package:result_dart/result_dart.dart";

class AuthRepository implements IAuthRepository {
  AuthRepository({
    required IMembersRepository membersRepository,
    required AuthApiClient authApiClient,
    required GoogleSignInService googleSignInService,
    required IBaseApiClient baseApiClient,
    required SecureStorageService sharedPreferencesService,
    required AuthListenable authListenable,
  }) : _membersRepository = membersRepository,
       _authApiClient = authApiClient,
       _googleSignInService = googleSignInService,
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
  final GoogleSignInService _googleSignInService;
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
      final error = memberResult.exceptionOrNull();
      _log.warning("Session validation failed for uuid: $uuid", error);
      if (error is ApiError &&
          (error.statusCode == 401 || error.statusCode == 404)) {
        await _secureStorageService.saveUuid(null);
        await _secureStorageService.saveToken(null);
        _currentUuidFuture = null;
        _authToken = null;
        _currentMember = null;
        _isAuthenticated = false;
      }
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
    final loginResult = await _authApiClient.loginAsync(email, password);

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
      await _secureStorageService.saveToken(null);
      await _secureStorageService.saveUuid(null);
      return Failure(userIdResult.exceptionOrNull()!);
    }

    final tokenResult = await _secureStorageService.saveToken(
      loginResponse.accessToken,
    );
    final refreshToken = loginResponse.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final refreshResult = await _secureStorageService.saveRefreshToken(
        refreshToken,
      );
      if (refreshResult.isError()) {
        return Failure(refreshResult.exceptionOrNull()!);
      }
    }
    if (tokenResult.isError()) {
      _log.severe("Failed to save auth token", tokenResult.exceptionOrNull());
      await _secureStorageService.saveUuid(null);
      return Failure(tokenResult.exceptionOrNull()!);
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
  AsyncResult<void> signUp(SignUpRequest signUpRequest) async {
    final result = await _authApiClient.signUpAsync(signUpRequest);
    if (result.isError()) {
      _log.warning("Failed to sign up", result.exceptionOrNull());
    }
    return result;
  }

  @override
  AsyncResult<LoginResponse> refresh(String refreshToken) =>
      refreshAsync(refreshToken);

  @override
  AsyncResult<void> logout() async {
    _log.info("Logging out");

    final logoutTokenResult = await _secureStorageService.fetchToken();
    final logoutToken = logoutTokenResult.getOrNull();
    final Result<void> apiResult;
    if (logoutToken == null || logoutToken.isEmpty) {
      apiResult = Success.unit();
    } else {
      apiResult = await _authApiClient.logout(logoutToken);
    }
    if (apiResult.isError()) {
      _log.warning(
        "API logout failed; continuing local logout",
        apiResult.exceptionOrNull(),
      );
    }

    // Clear local auth state
    _authToken = null;
    _currentUuidFuture = null;
    _currentMember = null;
    _isAuthenticated = false;
    // The session is gone: the cached validity must not survive the logout.
    _sessionValid = false;
    _validateSessionFuture = null;

    final refreshTokenResult = await _secureStorageService.saveRefreshToken(
      null,
    );
    if (refreshTokenResult.isError()) {
      _log.warning(
        "Failed to clear stored refresh token",
        refreshTokenResult.exceptionOrNull(),
      );
    }

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
  AsyncResult<void> resetPassword(String email) =>
      _authApiClient.resetPassword(email);

  @override
  String? get googleChallengeUrl => _authApiClient.googleChallengeUrl();

  @override
  AsyncResult<LoginResponse> signInWithGoogleAsync() async {
    final result = await _googleSignInService.launchGoogleSignIn();
    if (result.isError()) return result;
    final response = result.getOrNull();
    if (response == null) return Failure(Exception("Google response is null"));
    return _storeLoginResponse(response);
  }

  Future<Result<LoginResponse>> refreshAsync(String refreshToken) async {
    final result = await _authApiClient.refresh(refreshToken);
    if (result.isError()) {
      return result;
    }
    final response = result.getOrNull();
    if (response == null) {
      return Failure(Exception("Refresh response is null"));
    }
    return _storeLoginResponse(response);
  }

  @override
  AsyncResult<LoginResponse> googleCompleteAsync() async {
    final result = await _authApiClient.googleComplete();
    if (result.isError()) {
      return result;
    }
    final response = result.getOrNull();
    if (response == null) {
      return Failure(Exception("Google completion response is null"));
    }
    return _storeLoginResponse(response);
  }

  Future<Result<LoginResponse>> _storeLoginResponse(
    LoginResponse response,
  ) async {
    if (response.accessToken == null || response.accessToken!.isEmpty) {
      return Failure(Exception("Login response is missing access token"));
    }
    if (response.refreshToken == null || response.refreshToken!.isEmpty) {
      return Failure(Exception("Login response is missing refresh token"));
    }
    final uuidResult = await _secureStorageService.saveUuid(response.userId);
    final tokenResult = await _secureStorageService.saveToken(
      response.accessToken,
    );
    final refreshTokenResult = await _secureStorageService.saveRefreshToken(
      response.refreshToken,
    );
    if (uuidResult.isError()) return Failure(uuidResult.exceptionOrNull()!);
    if (tokenResult.isError()) return Failure(tokenResult.exceptionOrNull()!);
    if (refreshTokenResult.isError()) {
      return Failure(refreshTokenResult.exceptionOrNull()!);
    }
    _authToken = response.accessToken;
    _isAuthenticated = true;
    _currentUuidFuture = null;
    _currentMember = null;
    _sessionValid = null;
    _validateSessionFuture = null;
    return Success(response);
  }
}

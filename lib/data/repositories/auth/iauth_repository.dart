import "package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:result_dart/result_dart.dart";

abstract interface class IAuthRepository {
  Future<bool> get isAuthenticated;
  Future<String?> get currentUuid;

  /// Cached member entity from the most recent successful [validateSession],
  /// [login], or [signUp]. Null until at least one of those completes.
  /// Use this to avoid duplicate `GET /Members/uuid/{uuid}` calls across
  /// the router redirect and HomeCubit load flow.
  MembersEntity? get currentMember;

  /// Sets the cached member. Used by GetCurrentUserData to populate the
  /// cache after fetching user data, preventing duplicate API calls.
  void setCurrentMember(MembersEntity member);

  /// Validates that the current session is valid by checking
  /// that the member record exists in the backend.
  /// Returns true only if auth token exists AND member is found.
  /// On success, the member is cached and exposed via [currentMember].
  ///
  /// The result is cached: only the first call hits the network, the
  /// following ones are answered from the cache. The cache is dropped when
  /// the auth state changes (login, sign-up, logout) or when a validation
  /// fails, so the router redirect can call this on every navigation
  /// without a network round trip per navigation.
  Future<bool> validateSession();

  /// Invalidates the cached session validity after backend auth failure.
  void invalidateSession();

  AsyncResult<LoginResponse> login({
    required String email,
    required String password,
    String? phone,
  });

  AsyncResult<void> logout();

  AsyncResult<LoginResponse> refresh(String refreshToken);

  AsyncResult<void> signUp(SignUpRequest signUpRequest);

  AsyncResult<void> resetPassword(String email);

  /// Launches and completes the Google OAuth browser flow.
  AsyncResult<LoginResponse> signInWithGoogleAsync();

  /// Completes a Google OAuth flow after the callback has been received.
  AsyncResult<LoginResponse> googleCompleteAsync();

  String? get googleChallengeUrl;
}

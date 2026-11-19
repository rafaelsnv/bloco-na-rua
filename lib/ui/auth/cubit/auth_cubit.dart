import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:logging/logging.dart";
import "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  final AuthListenable _authListenable;
  final _log = Logger("AuthCubit");

  AuthCubit({
    required IAuthRepository authRepository,
    required AuthListenable authListenable,
  }) : _authRepository = authRepository,
       _authListenable = authListenable,
       super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (success) {
        _log.info("Login successful");
        emit(AuthAuthenticated());
        _authListenable.notify();
      },
      (error) {
        _log.warning("Login failed: $error");
        emit(AuthFailure(error, isSignup: false));
      },
    );
  }

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithGoogleAsync();
    result.fold(
      (success) {
        _log.info("Google sign-in successful");
        emit(AuthAuthenticated());
        _authListenable.notify();
      },
      (error) {
        _log.warning("Google sign-in failed: $error");
        emit(AuthFailure(error, isSignup: false));
      },
    );
  }

  Future<void> signUp(SignUpRequest signUpRequest) async {
    emit(AuthLoading());
    final result = await _authRepository.signUp(signUpRequest);

    result.fold(
      (success) {
        _log.info("Sign up successful");
        emit(const AuthSuccess(AuthSuccessKind.accountCreated));
      },
      (error) {
        _log.warning("Sign up failed: $error");
        emit(AuthFailure(error, isSignup: true));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _authRepository.logout();

    result.fold(
      (success) {
        _log.info("Logout successful");
        emit(AuthUnauthenticated());
        _authListenable.notify();
      },
      (error) {
        _log.warning("Logout failed: $error");
        emit(AuthFailure(error));
      },
    );
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    final result = await _authRepository.resetPassword(email);

    result.fold(
      (success) {
        _log.info("Password reset email sent");
        emit(const AuthSuccess(AuthSuccessKind.recoveryEmailSent));
        _authListenable.notify();
      },
      (error) {
        _log.warning("Failed to reset password: $error");
        emit(AuthFailure(error));
      },
    );
  }
}

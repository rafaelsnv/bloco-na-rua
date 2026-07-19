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
        final message = error.toString();
        _log.warning("Login failed: $message");
        emit(AuthFailure(message));
      },
    );
  }

  Future<void> signUp(SignUpRequest signUpRequest) async {
    emit(AuthLoading());
    final result = await _authRepository.signUp(signUpRequest);

    result.fold(
      (success) {
        _log.info("Sign up successful");
        emit(AuthEmailVerificationSent(email: signUpRequest.email));
        _authListenable.notify();
      },
      (error) {
        final message = error.toString();
        _log.warning("Sign up failed: $message");
        emit(AuthFailure(message));
      },
    );
  }

  Future<void> resendVerification(String email) async {
    emit(AuthLoading());
    final result = await _authRepository.resendVerification(email);

    result.fold(
      (success) {
        _log.info("Verification email resent");
        emit(const AuthSuccess(message: "E-mail de verificação reenviado!"));
      },
      (error) {
        final message = error.toString();
        _log.warning("Failed to resend verification: $message");
        emit(AuthFailure(message));
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
        final message = error.toString();
        _log.warning("Logout failed: $message");
        emit(AuthFailure(message));
      },
    );
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    final result = await _authRepository.resetPassword(email);

    result.fold(
      (success) {
        _log.info("Password reset email sent");
        emit(const AuthSuccess(message: "E-mail de recuperação enviado!"));
        _authListenable.notify();
      },
      (error) {
        final message = error.toString();
        _log.warning("Failed to reset password: $message");
        emit(AuthFailure(message));
      },
    );
  }
}

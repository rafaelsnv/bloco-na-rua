import 'package:bloco_na_rua/src/features/auth/interactor/entities/user_entity.dart';

sealed class AuthState{}

class LoggedAuthState implements AuthState {
  final UserEntity user;

  const LoggedAuthState({
    required this.user,
    });
}

class LogoutedAuthState implements AuthState {
  const LogoutedAuthState();
}

class LoadingAuthState implements AuthState {
  const LoadingAuthState();
}
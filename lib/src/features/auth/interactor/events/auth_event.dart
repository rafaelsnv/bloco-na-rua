import 'package:bloco_na_rua/src/features/auth/interactor/entities/user_entity.dart';

sealed class AuthEvent {}

class LoginAuthEvent implements AuthEvent {
  final String email;
  final String password;

  LoginAuthEvent({
    required this.email,
    required this.password,
  });
}

class CreateUserAuthEvent implements AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phone;

  CreateUserAuthEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}

class LogoutAuthEvent implements AuthEvent {}

class DeleteUserAuthEvent implements AuthEvent{
  final UserEntity user;
  DeleteUserAuthEvent({required this.user});
}
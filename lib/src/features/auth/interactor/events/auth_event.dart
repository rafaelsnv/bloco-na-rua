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
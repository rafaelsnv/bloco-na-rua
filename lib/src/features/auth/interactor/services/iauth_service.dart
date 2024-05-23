import 'dart:async';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';

abstract interface class IAuthService {
  Future<AuthState> login(String email, String password);

  Future<AuthState> logout();

  Future<AuthState> createUser(
    String email,
    String password,
    String name,
    String phone,
  );

  Future<AuthState> deleteUser();

  AuthState getUser();
}

import 'package:result_dart/result_dart.dart';

abstract interface class IAuthRepository {
  Future<bool> get isAuthenticated;

  AsyncResult<void> login({
    required String email,
    required String password,
    String? phone,
  });

  AsyncResult<void> logout();

  AsyncResult<void> signUp({required String email, required String password});
}

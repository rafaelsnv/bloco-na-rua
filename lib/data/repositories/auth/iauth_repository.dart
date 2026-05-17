import 'package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:flutter/widgets.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IAuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<String?> get currentUuid;

  /// Validates that the current session is valid by checking
  /// that the member record exists in the backend.
  /// Returns true only if auth token exists AND member is found.
  Future<bool> validateSession();

  AsyncResult<LoginResponse> login({
    required String email,
    required String password,
    String? phone,
  });

  AsyncResult<void> logout();

  AsyncResult<LoginResponse> signUp(SignUpRequest signUpRequest);

  AsyncResult<void> resetPassword(String email);
}

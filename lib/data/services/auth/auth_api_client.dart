import 'package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApiClient {
  AuthApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  AsyncResult<bool> signUp(String email, String password) async {
    try {
      var response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Failure(Exception("User not found"));
      }
      return Success(true);
    } on AuthException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<LoginResponse> logIn(LoginRequest loginRequest) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: loginRequest.email,
        phone: loginRequest.phone,
        password: loginRequest.password,
      );

      if (response.user == null) {
        return Failure(Exception("User not found"));
      }

      final loginResponse = LoginResponse(
        userId: response.user!.id,
        accessToken: response.session!.accessToken,
      );
      return Success(loginResponse);
    } catch (error) {
      return Failure(Exception('An error occurred: $error'));
    }
  }
}

import 'package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApiClient {
  AuthApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient {
    _supabaseClient.realtime.logger = _realtimeLogger;
  }

  final SupabaseClient _supabaseClient;

  final _logger = Logger('AuthApiClient');

  void _realtimeLogger(String? level, String? message, dynamic data) {
    // Use the _logger directly based on the level string
    switch (level?.toLowerCase()) {
      case 'info':
        _logger.info('$message - Data: $data');
        break;
      case 'warning':
        _logger.warning('$message - Data: $data');
        break;
      case 'severe':
        _logger.severe('$message - Data: $data');
        break;
      case 'shout':
        _logger.shout('$message - Data: $data');
        break;
      default:
        _logger.fine('$message - Data: $data'); // Default to fine
    }
  }

  AsyncResult<LoginResponse> logIn(LoginRequest loginRequest) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: loginRequest.email,
        password: loginRequest.password,
      );

      if (response.user == null) {
        return Failure(Exception("User not found"));
      }

      final result = LoginResponse(
        userId: response.user!.id,
        accessToken: response.session!.accessToken,
        refreshToken: response.session!.refreshToken,
      );
      return Success(result);
    } catch (error) {
      return Failure(Exception(error));
    }
  }

  AsyncResult<LoginResponse> signUp(SignUpRequest signUpRequest) async {
    try {
      var response = await _supabaseClient.auth.signUp(
        email: signUpRequest.email,
        // phone: signUpRequest.phone,
        password: signUpRequest.password,
      );

      if (response.session == null) {
        return Failure(Exception('Failed to login'));
      }

      final result = LoginResponse(
        userId: response.user!.id,
        accessToken: response.session!.accessToken,
        refreshToken: response.session!.refreshToken,
      );

      return Success(result);
    } catch (error) {
      return Failure(Exception(error));
    }
  }
}

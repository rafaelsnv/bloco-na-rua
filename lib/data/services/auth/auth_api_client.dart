import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApiClient {
  AuthApiClient({required IBaseApiClient baseApiClient})
      : _baseApiClient = baseApiClient;

  final IBaseApiClient _baseApiClient;

  final _logger = Logger('AuthApiClient');

  AsyncResult<LoginResponse> logIn(LoginRequest loginRequest) async {
    try {
      final response = await _baseApiClient.client.post(
        '${_baseApiClient.basePath}Auth/login',
        data: {
          'email': loginRequest.email,
          'password': loginRequest.password,
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      _logger.info('Login successful for: ${loginResponse.userId}');
      return Success(loginResponse);
    } catch (e) {
      _logger.warning('Login failed: $e');
      return Failure(Exception(e));
    }
  }

  AsyncResult<LoginResponse> signUp(SignUpRequest signUpRequest) async {
    try {
      var response = await Supabase.instance.client.auth.signUp(
        email: signUpRequest.email,
        password: signUpRequest.password,
      );

      if (response.user == null) {
        return Failure(Exception("User not found"));
      }

      if (response.session == null) {
        return Failure(Exception('Failed to login'));
      }

      final result = LoginResponse(
        userId: response.user!.id,
        accessToken: response.session!.accessToken,
        refreshToken: response.session!.refreshToken,
      );

      return Success(result);
    } on AuthException catch (ex) {
      _logger.warning(ex.message);
      return Failure(Exception("${ex.message} - ${ex.statusCode}"));
    } catch (ex) {
      return Failure(Exception(ex));
    }
  }

  AsyncResult<void> resetPassword(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      return Success.unit();
    } on AuthException catch (ex) {
      _logger.warning(ex.message);
      return Failure(Exception("${ex.message} - ${ex.statusCode}"));
    } catch (ex) {
      return Failure(Exception(ex));
    }
  }

  AsyncResult<void> resendVerification(String email) async {
    try {
      await Supabase.instance.client.auth.resend(email: email, type: OtpType.signup);
      return Success.unit();
    } on AuthException catch (ex) {
      _logger.warning(ex.message);
      return Failure(Exception("${ex.message} - ${ex.statusCode}"));
    } catch (ex) {
      return Failure(Exception(ex));
    }
  }
}

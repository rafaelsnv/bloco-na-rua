import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart' show ApiV1AuthLoginPost$RequestBody, LoginResponse;
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApiClient {
  AuthApiClient({required IBaseApiClient baseApiClient});

  final _logger = Logger('AuthApiClient');

  AsyncResult<LoginResponse> logIn(ApiV1AuthLoginPost$RequestBody loginRequest) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: loginRequest.email!,
        password: loginRequest.password!,
      );

      if (response.user == null) {
        return Failure(Exception("User not found"));
      }

      if (response.session == null) {
        return Failure(Exception('Failed to login'));
      }

      final loginResponse = LoginResponse(
        userId: response.user!.id,
        accessToken: response.session!.accessToken,
        refreshToken: response.session!.refreshToken,
      );
      _logger.info('Login successful for: ${loginResponse.userId}');
      return Success(loginResponse);
    } on AuthException catch (ex) {
      _logger.warning('Login failed: ${ex.message}');
      return Failure(Exception("${ex.message} - ${ex.statusCode}"));
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

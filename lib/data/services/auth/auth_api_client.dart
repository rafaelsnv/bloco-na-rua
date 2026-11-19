import 'dart:convert';

import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart'
    show ApiV1AuthLoginPost$RequestBody, LoginResponse;
import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class AuthApiClient {
  AuthApiClient({required this.baseApiClient});

  final IBaseApiClient baseApiClient;

  static const _basePath = '/api/v1/Auth';

  AsyncResult<LoginResponse> loginAsync(String email, String password) =>
      logIn(ApiV1AuthLoginPost$RequestBody(email: email, password: password));

  AsyncResult<LoginResponse> logIn(
    ApiV1AuthLoginPost$RequestBody loginRequest,
  ) async {
    try {
      final response = await baseApiClient.client.post(
        '$_basePath/login',
        data: _formBody({
          'Email': loginRequest.email,
          'Password': loginRequest.password,
        }),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success(_loginResponse(response.data));
    } on DioException catch (error) {
      return Failure(ApiError.fromDioException(error));
    } catch (error) {
      return Failure(_unexpected(error));
    }
  }

  AsyncResult<void> signUpAsync(SignUpRequest signUpRequest) =>
      signUp(signUpRequest);

  AsyncResult<void> signUp(SignUpRequest signUpRequest) async {
    try {
      final response = await baseApiClient.client.post(
        '$_basePath/signup',
        data: _formBody({
          'Email': signUpRequest.email,
          'Password': signUpRequest.password,
          'Name': signUpRequest.name,
        }),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 201) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success.unit();
    } on DioException catch (error) {
      return Failure(ApiError.fromDioException(error));
    } catch (error) {
      return Failure(_unexpected(error));
    }
  }

  AsyncResult<LoginResponse> refresh(String refreshToken) async {
    try {
      final response = await baseApiClient.client.post(
        '$_basePath/refresh',
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode != 200) {
        return Failure(ApiError.fromResponse(response));
      }
      // ponytail: Swagger omits this response schema; assume LoginResponse
      // until the backend documents the actual refresh response.
      return Success(_loginResponse(response.data));
    } on DioException catch (error) {
      return Failure(ApiError.fromDioException(error));
    } catch (error) {
      return Failure(_unexpected(error));
    }
  }

  AsyncResult<void> logout(String accessToken) async {
    try {
      final response = await baseApiClient.client.post(
        '$_basePath/logout',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      return Success.unit();
    } on DioException catch (error) {
      return Failure(ApiError.fromDioException(error));
    } catch (error) {
      return Failure(_unexpected(error));
    }
  }

  /// Full challenge endpoint for the browser/deep-link OAuth flow.
  String googleChallengeUrl() => _absoluteUrl('$_basePath/google/challenge');

  AsyncResult<LoginResponse> googleComplete() async {
    try {
      final response = await baseApiClient.client.get(
        '$_basePath/google/complete',
      );
      if (response.statusCode != 200) {
        return Failure(baseApiClient.formatError(response));
      }
      // ponytail: /complete 200 body is undocumented in swagger; parsed as LoginResponse.
      // Contract confirmed (backend AuthController.cs): /complete is session-bound —
      // it requires the single-use HttpOnly bnr_google_state cookie created by
      // /challenge (10-min expiry, one-time replay), so forged callbacks get 401.
      // Caveat: the cookie binds the device's browser, not this app instance — within
      // the window anything sharing the browser cookie jar could complete the flow.
      // RFC 8252 tradeoff; per-instance state nonce only if needed later.
      return Success(_loginResponse(response.data));
    } on DioException catch (error) {
      return Failure(ApiError.fromDioException(error));
    } catch (error) {
      return Failure(_unexpected(error));
    }
  }

  // Password reset remains intentionally stubbed; no backend endpoint exists.
  AsyncResult<void> resetPassword(String email) async => Failure(
    ApiError(
      type: ApiErrorType.unknown,
      userMessage: 'Password reset is not available.',
      technicalMessage: 'No password reset endpoint is documented.',
    ),
  );

  AsyncResult<void> resendVerification(String email) async => Failure(
    ApiError(
      type: ApiErrorType.unknown,
      userMessage: 'Email verification is not available.',
      technicalMessage: 'No email verification endpoint is documented.',
    ),
  );

  String _formBody(Map<String, String?> values) => Uri(
    queryParameters: values.map((key, value) => MapEntry(key, value ?? '')),
  ).query;

  LoginResponse _loginResponse(Object? data) {
    final decoded = data is String ? jsonDecode(data) : data;
    if (decoded is! Map) {
      throw const FormatException('Expected a JSON object for LoginResponse');
    }
    return LoginResponse.fromJson(Map<String, dynamic>.from(decoded));
  }

  String _absoluteUrl(String path) {
    final baseUrl = baseApiClient.client.options.baseUrl;
    final separator = baseUrl.endsWith('/') ? '' : '/';
    final relativePath = path.startsWith('/') ? path.substring(1) : path;
    return '$baseUrl$separator$relativePath';
  }

  ApiError _unexpected(Object error) => ApiError(
    type: ApiErrorType.unknown,
    userMessage: 'Something unexpected happened. Try again.',
    technicalMessage: error.toString(),
  );
}

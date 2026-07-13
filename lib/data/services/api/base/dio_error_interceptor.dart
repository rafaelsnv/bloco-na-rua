import 'package:dio/dio.dart';

import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_messages.dart';
import 'package:bloco_na_rua/core/error_types.dart';

/// Dio interceptor that catches errors and transforms them into
/// structured ApiError instances for consistent error handling.
class DioErrorInterceptor extends Interceptor {
  /// Key used to store ApiError in response extra for access after request
  static const apiErrorKey = 'api_error';

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiError = _mapDioExceptionToApiError(err);

    // Store ApiError in response extra for downstream access
    if (err.response != null) {
      err.response!.extra[apiErrorKey] = apiError;
    }

    handler.next(err);
  }

  /// Maps a DioException to an ApiError with appropriate message
  ApiError _mapDioExceptionToApiError(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          type: ApiErrorType.timeout,
          userMessage: ErrorMessages.timeout,
          technicalMessage: exception.message,
          statusCode: exception.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiError(
          type: ApiErrorType.network,
          userMessage: ErrorMessages.network,
          technicalMessage: exception.message,
        );

      case DioExceptionType.badResponse:
        return _mapBadResponse(exception.response);

      case DioExceptionType.cancel:
        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: ErrorMessages.unknown,
          technicalMessage: 'Request cancelled: ${exception.message}',
        );

      case DioExceptionType.badCertificate:
        return ApiError(
          type: ApiErrorType.network,
          userMessage: ErrorMessages.network,
          technicalMessage: 'Certificate error: ${exception.message}',
        );

      case DioExceptionType.unknown:
        // Check if it's a network error
        final msg = exception.message ?? '';
        if (msg.contains('SocketException') ||
            msg.contains('ConnectionRefused')) {
          return ApiError(
            type: ApiErrorType.network,
            userMessage: ErrorMessages.network,
            technicalMessage: exception.message,
          );
        }
        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: ErrorMessages.unknown,
          technicalMessage: exception.message,
        );
    }
  }

  /// Maps a bad HTTP response to an ApiError based on status code
  ApiError _mapBadResponse(Response? response) {
    final statusCode = response?.statusCode;

    if (statusCode == null) {
      return ApiError(
        type: ApiErrorType.unknown,
        userMessage: ErrorMessages.unknown,
        technicalMessage: 'Response with no status code',
      );
    }

    switch (statusCode) {
      case 400:
        return ApiError(
          type: ApiErrorType.validation,
          userMessage: ErrorMessages.validation,
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 401:
        return ApiError(
          type: ApiErrorType.auth,
          userMessage: ErrorMessages.authExpired,
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 403:
        return ApiError(
          type: ApiErrorType.auth,
          userMessage: ErrorMessages.authForbidden,
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 404:
        return ApiError(
          type: ApiErrorType.notFound,
          userMessage: ErrorMessages.notFound,
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 503:
        return ApiError(
          type: ApiErrorType.server,
          userMessage: ErrorMessages.server503,
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      default:
        if (statusCode >= 500) {
          return ApiError(
            type: ApiErrorType.server,
            userMessage: ErrorMessages.server5xx,
            technicalMessage: response?.statusMessage ?? '',
            statusCode: statusCode,
          );
        }

        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: ErrorMessages.unknown,
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );
    }
  }
}

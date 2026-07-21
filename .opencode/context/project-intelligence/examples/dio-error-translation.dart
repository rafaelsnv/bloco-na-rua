// examples/dio-error-translation.dart
//
// Canonical reference for translating DioException → ApiError.
// Mirrors the actual `lib/core/api_error.dart` factory.

import 'package:dio/dio.dart';

import 'package:bloco_na_rua/core/error_messages.dart';
import 'package:bloco_na_rua/core/error_types.dart';

class ApiError implements Exception {
  final ApiErrorType type;
  final String userMessage;        // shown to user (pt-BR)
  final String? technicalMessage;  // logged
  final int? statusCode;

  const ApiError({
    required this.type,
    required this.userMessage,
    this.technicalMessage,
    this.statusCode,
  });

  /// Translate DioException → ApiError with pt-BR user message.
  factory ApiError.fromDioException(DioException exception) {
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
        return ApiError.fromResponse(exception.response);

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

  /// Translate response (when DioExceptionType.badResponse) → ApiError.
  factory ApiError.fromResponse(Response? response) {
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

  @override
  String toString() => 'ApiError(type: $type, message: $userMessage)';
}

// Usage in a Repository:
//
// try {
//   final list = await _api.getByBlock(blockId);
//   return Success(list);
// } on DioException catch (e) {
//   _log.warning('getByBlock($blockId) failed', e);
//   return Failure(ApiError.fromDioException(e));
// } catch (e) {
//   return Failure(Exception(e.toString()));
// }

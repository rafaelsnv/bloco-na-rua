import 'package:bloco_na_rua/core/error_messages.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

/// Centralized API error class that encapsulates error information
/// with user-friendly messages.
class ApiError implements Exception {
  static final Logger _log = Logger('ApiError');

  /// The type/category of the error
  final ApiErrorType type;

  /// Optional non-localized fallback for callers without a [BuildContext].
  /// API failures created here are localized from [type] at render time.
  final String? userMessage;

  /// Technical message for logging and debugging
  final String? technicalMessage;

  /// HTTP status code if available
  final int? statusCode;

  const ApiError({
    required this.type,
    required this.userMessage,
    this.technicalMessage,
    this.statusCode,
  });

  /// True when the error is auth-related (401 Unauthorized / 403 Forbidden),
  /// so the cached session validity can no longer be trusted.
  ///
  /// A 401 means the session was revoked or expired; a 403 means the
  /// session is fine but the action is not permitted. Both make the cached
  /// answer stale, so it has to be re-checked against the backend.
  bool get isAuthFailure => type == ApiErrorType.auth;

  /// Returns the user-facing message.
  ///
  /// If [context] is provided, returns the localized message for the current locale.
  /// Otherwise returns the non-localized fallback (English by default).
  String toUserMessage([BuildContext? context]) {
    if (context != null) {
      return ErrorMessages.forType(context, type, statusCode);
    }
    return userMessage ?? type.name;
  }

  /// Creates an ApiError from a DioException
  factory ApiError.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          type: ApiErrorType.timeout,
          userMessage: 'timeout',
          technicalMessage: exception.message,
          statusCode: exception.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiError(
          type: ApiErrorType.network,
          userMessage: 'network',
          technicalMessage: exception.message,
        );

      case DioExceptionType.badResponse:
        return ApiError.fromResponse(exception.response);

      case DioExceptionType.cancel:
        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'unknown',
          technicalMessage: 'Request cancelled: ${exception.message}',
        );

      case DioExceptionType.badCertificate:
        return ApiError(
          type: ApiErrorType.network,
          userMessage: 'network',
          technicalMessage: 'Certificate error: ${exception.message}',
        );

      case DioExceptionType.unknown:
        // Check if it's a network error
        final msg = exception.message ?? '';
        if (msg.contains('SocketException') ||
            msg.contains('ConnectionRefused')) {
          return ApiError(
            type: ApiErrorType.network,
            userMessage: 'network',
            technicalMessage: exception.message,
          );
        }
        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'unknown',
          technicalMessage: exception.message,
        );
      case DioExceptionType.transformTimeout:
        return ApiError(
          type: ApiErrorType.timeout,
          userMessage: 'timeout',
          technicalMessage: exception.message,
          statusCode: exception.response?.statusCode,
        );
    }
  }

  /// Creates an ApiError from an HTTP response with status code
  factory ApiError.fromResponse(Response? response) {
    final statusCode = response?.statusCode;

    if (statusCode == null) {
      return ApiError(
        type: ApiErrorType.unknown,
        userMessage: 'unknown',
        technicalMessage: 'Response with no status code',
      );
    }

    switch (statusCode) {
      case 400:
        // Backend field-level errors live in the body (e.g. {"Phone": [...]}),
        // not statusMessage — log the body or they're lost.
        _log.severe('API 400: ${response?.data}');
        return ApiError(
          type: ApiErrorType.validation,
          userMessage: 'validation',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 401:
        return ApiError(
          type: ApiErrorType.auth,
          userMessage: 'authExpired',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 403:
        return ApiError(
          type: ApiErrorType.auth,
          userMessage: 'authForbidden',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 404:
        return ApiError(
          type: ApiErrorType.notFound,
          userMessage: 'notFound',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 503:
        return ApiError(
          type: ApiErrorType.server,
          userMessage: 'server503',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      default:
        if (statusCode >= 500) {
          return ApiError(
            type: ApiErrorType.server,
            userMessage: 'server5xx',
            technicalMessage: response?.statusMessage ?? '',
            statusCode: statusCode,
          );
        }

        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'unknown',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() => 'ApiError(type: $type, message: $userMessage)';
}

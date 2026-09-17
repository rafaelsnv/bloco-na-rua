import 'package:bloco_na_rua/core/error_messages.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

/// Centralized API error class that encapsulates error information
/// with user-friendly messages.
class ApiError implements Exception {
  /// The type/category of the error
  final ApiErrorType type;

  /// Human-readable fallback message (non-localized, used when no context available).
  /// Defaults to English from ARB catalog.
  final String userMessage;

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

  /// Returns the user-facing message.
  ///
  /// If [context] is provided, returns the localized message for the current locale.
  /// Otherwise returns the non-localized fallback (English by default).
  String toUserMessage([BuildContext? context]) {
    if (context != null) {
      return ErrorMessages.forType(context, type, statusCode);
    }
    return userMessage;
  }

  /// Creates an ApiError from a DioException
  factory ApiError.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          type: ApiErrorType.timeout,
          userMessage: 'Slow connection. Check your internet or try again.',
          technicalMessage: exception.message,
          statusCode: exception.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiError(
          type: ApiErrorType.network,
          userMessage: 'No internet connection. Check your Wi-Fi.',
          technicalMessage: exception.message,
        );

      case DioExceptionType.badResponse:
        return ApiError.fromResponse(exception.response);

      case DioExceptionType.cancel:
        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'Something unexpected happened. Try again.',
          technicalMessage: 'Request cancelled: ${exception.message}',
        );

      case DioExceptionType.badCertificate:
        return ApiError(
          type: ApiErrorType.network,
          userMessage: 'No internet connection. Check your Wi-Fi.',
          technicalMessage: 'Certificate error: ${exception.message}',
        );

      case DioExceptionType.unknown:
        // Check if it's a network error
        final msg = exception.message ?? '';
        if (msg.contains('SocketException') ||
            msg.contains('ConnectionRefused')) {
          return ApiError(
            type: ApiErrorType.network,
            userMessage: 'No internet connection. Check your Wi-Fi.',
            technicalMessage: exception.message,
          );
        }
        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'Something unexpected happened. Try again.',
          technicalMessage: exception.message,
        );
      case DioExceptionType.transformTimeout:
        // TO-DO: Handle this case.
        throw UnimplementedError();
    }
  }

  /// Creates an ApiError from an HTTP response with status code
  factory ApiError.fromResponse(Response? response) {
    final statusCode = response?.statusCode;

    if (statusCode == null) {
      return ApiError(
        type: ApiErrorType.unknown,
        userMessage: 'Something unexpected happened. Try again.',
        technicalMessage: 'Response with no status code',
      );
    }

    switch (statusCode) {
      case 400:
        return ApiError(
          type: ApiErrorType.validation,
          userMessage: 'Invalid data. Check the information.',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 401:
        return ApiError(
          type: ApiErrorType.auth,
          userMessage: 'Session expired. Please log in again.',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 403:
        return ApiError(
          type: ApiErrorType.auth,
          userMessage: "You don't have permission for this action.",
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 404:
        return ApiError(
          type: ApiErrorType.notFound,
          userMessage: 'Resource not found.',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      case 503:
        return ApiError(
          type: ApiErrorType.server,
          userMessage: 'Server temporarily unavailable. Try again later.',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );

      default:
        if (statusCode >= 500) {
          return ApiError(
            type: ApiErrorType.server,
            userMessage: 'Server error. Try again later.',
            technicalMessage: response?.statusMessage ?? '',
            statusCode: statusCode,
          );
        }

        return ApiError(
          type: ApiErrorType.unknown,
          userMessage: 'Something unexpected happened. Try again.',
          technicalMessage: response?.statusMessage ?? '',
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() => 'ApiError(type: $type, message: $userMessage)';
}

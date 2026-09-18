import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/error_types.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:test/test.dart";

class _MockResponse extends Mock implements Response<dynamic> {}

class _MockDioException extends Mock implements DioException {}

Response<dynamic> _mockResponse(int statusCode, {String statusMessage = ""}) {
  final response = _MockResponse();
  when(() => response.statusCode).thenReturn(statusCode);
  when(() => response.statusMessage).thenReturn(statusMessage);
  return response;
}

DioException _mockDioException({
  required DioExceptionType type,
  String? message,
  Response<dynamic>? response,
}) {
  final exception = _MockDioException();
  when(() => exception.type).thenReturn(type);
  when(() => exception.message).thenReturn(message);
  when(() => exception.response).thenReturn(response);
  return exception;
}

void main() {
  group("ApiError.fromDioException", () {
    group("timeout branches map to ApiErrorType.timeout", () {
      test("connectionTimeout", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.connectionTimeout,
          message: "connection timed out",
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.timeout));
        expect(
          error.userMessage,
          equals("Slow connection. Check your internet or try again."),
        );
        expect(error.technicalMessage, equals("connection timed out"));
        expect(error.statusCode, isNull);
      });

      test("sendTimeout", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.sendTimeout,
          message: "send timed out",
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.timeout));
        expect(
          error.userMessage,
          equals("Slow connection. Check your internet or try again."),
        );
        expect(error.technicalMessage, equals("send timed out"));
        expect(error.statusCode, isNull);
      });

      test("receiveTimeout", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.receiveTimeout,
          message: "receive timed out",
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.timeout));
        expect(
          error.userMessage,
          equals("Slow connection. Check your internet or try again."),
        );
        expect(error.technicalMessage, equals("receive timed out"));
        expect(error.statusCode, isNull);
      });

      test("timeout branches propagate statusCode from response", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.receiveTimeout,
          message: "Gateway Timeout",
          response: _mockResponse(504),
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.timeout));
        expect(error.statusCode, equals(504));
      });
    });

    test("connectionError maps to network error", () {
      // Arrange
      final exception = _mockDioException(
        type: DioExceptionType.connectionError,
        message: "Failed host lookup",
      );

      // Act
      final error = ApiError.fromDioException(exception);

      // Assert
      expect(error.type, equals(ApiErrorType.network));
      expect(
        error.userMessage,
        equals("No internet connection. Check your Wi-Fi."),
      );
      expect(error.technicalMessage, equals("Failed host lookup"));
      expect(error.statusCode, isNull);
    });

    test("badCertificate maps to network error with certificate prefix", () {
      // Arrange
      final exception = _mockDioException(
        type: DioExceptionType.badCertificate,
        message: "Cert verify failed",
      );

      // Act
      final error = ApiError.fromDioException(exception);

      // Assert
      expect(error.type, equals(ApiErrorType.network));
      expect(
        error.userMessage,
        equals("No internet connection. Check your Wi-Fi."),
      );
      expect(
        error.technicalMessage,
        equals("Certificate error: Cert verify failed"),
      );
      expect(error.statusCode, isNull);
    });

    test("cancel maps to unknown error with cancellation prefix", () {
      // Arrange
      final exception = _mockDioException(
        type: DioExceptionType.cancel,
        message: "cancelled by user",
      );

      // Act
      final error = ApiError.fromDioException(exception);

      // Assert
      expect(error.type, equals(ApiErrorType.unknown));
      expect(
        error.userMessage,
        equals("Something unexpected happened. Try again."),
      );
      expect(
        error.technicalMessage,
        equals("Request cancelled: cancelled by user"),
      );
      expect(error.statusCode, isNull);
    });

    group("unknown branch", () {
      test("SocketException message maps to network error", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.unknown,
          message: "SocketException: Failed host lookup (OS Error: ...)",
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.network));
        expect(
          error.userMessage,
          equals("No internet connection. Check your Wi-Fi."),
        );
      });

      test("ConnectionRefused message maps to network error", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.unknown,
          message: "ConnectionRefused: cannot connect to server",
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.network));
        expect(
          error.userMessage,
          equals("No internet connection. Check your Wi-Fi."),
        );
      });

      test("generic message maps to unknown error", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.unknown,
          message: "Some random parse error",
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.unknown));
        expect(
          error.userMessage,
          equals("Something unexpected happened. Try again."),
        );
        expect(error.technicalMessage, equals("Some random parse error"));
      });

      test("null message maps to unknown error", () {
        // Arrange
        final exception = _mockDioException(
          type: DioExceptionType.unknown,
          message: null,
        );

        // Act
        final error = ApiError.fromDioException(exception);

        // Assert
        expect(error.type, equals(ApiErrorType.unknown));
        expect(
          error.userMessage,
          equals("Something unexpected happened. Try again."),
        );
        expect(error.technicalMessage, isNull);
      });
    });
  });

  group("ApiError.fromResponse", () {
    test("400 maps to validation error", () {
      // Arrange
      final response = _mockResponse(400);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.validation));
      expect(error.statusCode, equals(400));
      expect(error.userMessage, equals("Invalid data. Check the information."));
    });

    test("401 maps to auth error", () {
      // Arrange
      final response = _mockResponse(401);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.auth));
      expect(error.statusCode, equals(401));
      expect(error.userMessage, equals("Session expired. Please log in again."));
    });

    test("403 maps to auth error", () {
      // Arrange
      final response = _mockResponse(403);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.auth));
      expect(error.statusCode, equals(403));
      expect(
        error.userMessage,
        equals("You don't have permission for this action."),
      );
    });

    test("404 maps to notFound error", () {
      // Arrange
      final response = _mockResponse(404);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.notFound));
      expect(error.statusCode, equals(404));
      expect(error.userMessage, equals("Resource not found."));
    });

    test("500 maps to server error", () {
      // Arrange
      final response = _mockResponse(500);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.server));
      expect(error.statusCode, equals(500));
      expect(error.userMessage, equals("Server error. Try again later."));
    });

    test("503 maps to server error", () {
      // Arrange
      final response = _mockResponse(503);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.server));
      expect(error.statusCode, equals(503));
      expect(
        error.userMessage,
        equals("Server temporarily unavailable. Try again later."),
      );
    });

    test("null response returns unknown error", () {
      // Arrange
      // (no response)

      // Act
      final error = ApiError.fromResponse(null);

      // Assert
      expect(error.type, equals(ApiErrorType.unknown));
      expect(error.statusCode, isNull);
      expect(
        error.userMessage,
        equals("Something unexpected happened. Try again."),
      );
    });

    test("statusCode 0 returns unknown error", () {
      // Arrange
      final response = _mockResponse(0);

      // Act
      final error = ApiError.fromResponse(response);

      // Assert
      expect(error.type, equals(ApiErrorType.unknown));
      expect(error.statusCode, equals(0));
      expect(
        error.userMessage,
        equals("Something unexpected happened. Try again."),
      );
    });
  });
}

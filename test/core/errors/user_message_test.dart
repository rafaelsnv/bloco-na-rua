import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/core/error_types.dart";
import "package:test/test.dart";

void main() {
  group("extractUserMessage", () {
    test("handles ApiError with userMessage", () {
      // Arrange
      const apiError = ApiError(
        type: ApiErrorType.network,
        userMessage: "Sem conexão com a internet",
      );

      // Act
      final result = extractUserMessage(apiError);

      // Assert
      expect(result, equals("Sem conexão com a internet"));
    });

    test("handles Exception with 'Exception: ' prefix", () {
      // Arrange
      final exception = Exception("Algo deu errado");

      // Act
      final result = extractUserMessage(exception);

      // Assert
      expect(result, equals("Algo deu errado"));
    });

    test("handles generic Exception without 'Exception: ' prefix", () {
      // Arrange
      final exception = Exception("generic error message");

      // Act
      final result = extractUserMessage(exception);

      // Assert
      expect(result, equals("generic error message"));
    });

    test("handles null", () {
      // Act
      final result = extractUserMessage(null);

      // Assert
      expect(result, equals("Erro desconhecido"));
    });
  });
}

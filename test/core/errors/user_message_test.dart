import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/error_types.dart";
import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class _MockBuildContext extends Mock implements BuildContext {}

/// Pumps a [Builder] inside a [Localizations] widget so the captured
/// [BuildContext] resolves a real [AppLocalizations] via
/// [AppLocalizations.of]. Used by tests that assert on the localized branch.
Future<BuildContext> _pumpContextWithLocalizations(WidgetTester tester) async {
  late BuildContext captured;
  await tester.pumpWidget(
    Localizations(
      locale: const Locale("en"),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      child: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return captured;
}

/// Pumps a bare [Builder] with no [Localizations] ancestor so
/// [AppLocalizations.of] returns null on the captured [BuildContext].
Future<BuildContext> _pumpBareContext(WidgetTester tester) async {
  late BuildContext captured;
  await tester.pumpWidget(
    Builder(
      builder: (context) {
        captured = context;
        return const SizedBox.shrink();
      },
    ),
  );
  return captured;
}

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

  group("extractUserMessageWithContext", () {
    testWidgets(
      "returns generic fallback message when error is null",
      (tester) async {
        // Arrange
        final context = _MockBuildContext();

        // Act
        final result = extractUserMessageWithContext(null, context);

        // Assert — early return on null error, context is never queried.
        expect(result, equals("Erro desconhecido"));
      },
    );

    testWidgets(
      "falls back to userMessage when context has no AppLocalizations",
      (tester) async {
        // Arrange — pump a bare widget tree so AppLocalizations.of returns null
        final context = await _pumpBareContext(tester);
        const apiError = ApiError(
          type: ApiErrorType.network,
          userMessage: "Sem conexão com a internet",
        );

        // Act
        final result = extractUserMessageWithContext(apiError, context);

        // Assert
        expect(result, equals("Sem conexão com a internet"));
      },
    );

    testWidgets(
      "returns localized message for ApiError when context provides AppLocalizations",
      (tester) async {
        // Arrange
        final context = await _pumpContextWithLocalizations(tester);
        const apiError = ApiError(
          type: ApiErrorType.network,
          userMessage: "fallback userMessage",
        );

        // Act
        final result = extractUserMessageWithContext(apiError, context);

        // Assert — localized from AppLocalizationsEn.network, NOT the fallback.
        expect(
          result,
          equals("No internet connection. Check your Wi-Fi."),
        );
      },
    );

    testWidgets(
      "strips 'Exception: ' prefix for plain Exception when context is provided",
      (tester) async {
        // Arrange
        final context = _MockBuildContext();
        final exception = Exception("Algo deu errado");

        // Act
        final result = extractUserMessageWithContext(exception, context);

        // Assert — Exception branch never queries context for localizations.
        expect(result, equals("Algo deu errado"));
      },
    );
  });
}

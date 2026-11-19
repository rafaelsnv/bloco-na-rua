// Regression lock-in for the error handling wave (H4 / M4).
//
// - H4 — every user-facing failure message goes through `extractUserMessage`,
//   so no raw `Exception: ` prefix reaches the UI.
// - M4 — the error states render through `AppError` (backed by
//   `AppStateView`), including the inline `compact` variant used by the
//   section panels of the block details screen.
//
// House style follows the existing tests in `test/`: `flutter_test` only and
// Arrange / Act / Assert inside every test body.

import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/core/error_types.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

/// The Portuguese catalog, read straight from the ARB-generated localizations.
///
/// The copy the error widget renders moved into the catalog during the
/// ARB/i18n migration, so the expectations are built from the same source the
/// widget reads from.
final AppLocalizations _pt = lookupAppLocalizations(const Locale("pt"));

/// The app shell used by every harness below.
///
/// Since the ARB/i18n migration the core widgets read their copy through
/// `AppLocalizations.of(context)!`, so a bare `MaterialApp` crashes the build
/// with a null-check error. The delegates and the explicit `pt` locale keep
/// the Portuguese copy the assertions below expect.
Widget _app({required Widget home}) => MaterialApp(
  theme: AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  home: home,
);

void main() {
  group("H4 — extractUserMessage strips the technical prefix", () {
    test("H4: a nested 'Exception: ' prefix never reaches the user", () {
      // Arrange
      final failure = Exception("Unexpected error: Exception: boom");

      // Act
      final result = extractUserMessage(failure);

      // Assert — both prefixes are gone.
      expect(result, "Unexpected error: boom");
      expect(result, isNot(contains("Exception:")));
    });

    test("H4: an ApiError keeps its user message, not its toString", () {
      // Arrange
      const apiError = ApiError(
        type: ApiErrorType.network,
        userMessage: "Sem conexão com a internet",
      );

      // Act
      final result = extractUserMessage(apiError);

      // Assert
      expect(result, "Sem conexão com a internet");
      expect(result, isNot(contains("ApiError")));
    });

    test("H4: a longer exception name is not mangled", () {
      // Arrange
      final failure = FormatException("campo inválido");

      // Act
      final result = extractUserMessage(failure);

      // Assert — only the bare `Exception: ` prefix is technical.
      expect(result, "FormatException: campo inválido");
    });
  });

  group("M4 — AppError renders the inline (compact) variant", () {
    testWidgets("M4: the compact error shows the message and the retry", (
      tester,
    ) async {
      // Arrange
      var retried = false;
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppError(
              compact: true,
              message: _pt.unknown,
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      // Assert — the message and the retry action are both there.
      expect(find.text(_pt.unknown), findsOneWidget);
      expect(find.text(_pt.coreRetry), findsOneWidget);

      // Assert — the compact variant drops the full-screen title.
      expect(find.text(_pt.coreErrorTitle), findsNothing);

      // Act — the retry button is live.
      await tester.tap(find.text(_pt.coreRetry));
      await tester.pump();

      // Assert
      expect(retried, isTrue);
    });
  });
}

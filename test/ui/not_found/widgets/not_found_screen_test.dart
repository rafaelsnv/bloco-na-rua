import "package:bloco_na_rua/ui/not_found/widgets/not_found_screen.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale("pt"),
      home: child,
    );
  }

  group("NotFoundScreen", () {
    testWidgets("renders without exceptions", (tester) async {
      await tester.pumpWidget(buildTestWidget(const NotFoundScreen()));
      await tester.pumpAndSettle();
    });

    testWidgets("displays 404 text", (tester) async {
      await tester.pumpWidget(buildTestWidget(const NotFoundScreen()));
      await tester.pumpAndSettle();
      expect(find.text("404"), findsOneWidget);
    });

    testWidgets("displays back button", (tester) async {
      await tester.pumpWidget(buildTestWidget(const NotFoundScreen()));
      await tester.pumpAndSettle();
      expect(find.text("Voltar"), findsOneWidget);
    });

    testWidgets("displays error icon", (tester) async {
      await tester.pumpWidget(buildTestWidget(const NotFoundScreen()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });
  });
}

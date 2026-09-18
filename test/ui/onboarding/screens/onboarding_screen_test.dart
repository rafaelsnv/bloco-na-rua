import "package:bloco_na_rua/ui/onboarding/onboarding_wrapper.dart";
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

  group("OnboardingWrapper", () {
    testWidgets("renders without exceptions", (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingWrapper()));
      await tester.pumpAndSettle();
    });

    testWidgets("displays skip button", (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingWrapper()));
      await tester.pumpAndSettle();
      expect(find.text("Pular"), findsOneWidget);
    });

    testWidgets("displays next button", (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingWrapper()));
      await tester.pumpAndSettle();
      expect(find.text("Próximo"), findsOneWidget);
    });

    testWidgets("displays first onboarding screen text", (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingWrapper()));
      await tester.pumpAndSettle();
      expect(find.text("O que é um bloco?"), findsOneWidget);
    });
  });
}

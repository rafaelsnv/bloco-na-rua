import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppLoading", () {
    testWidgets("renders CircularProgressIndicator by default", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLoading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_top_rounded), findsNothing);
    });

    testWidgets("renders with custom message", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoading(message: "Carregando...")),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Carregando..."), findsOneWidget);
    });

    testWidgets("renders with custom size", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoading(size: 60)),
        ),
      );

      // Verify the SizedBox parent wrapping CircularProgressIndicator has correct size
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 60);
      expect(sizedBox.height, 60);
    });

    testWidgets("renders hourglass icon when animations are disabled", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(body: AppLoading()),
          ),
        ),
      );

      expect(find.byIcon(Icons.hourglass_top_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("renders message with hourglass icon when animations disabled", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(body: AppLoading(message: "Aguarde")),
          ),
        ),
      );

      expect(find.byIcon(Icons.hourglass_top_rounded), findsOneWidget);
      expect(find.text("Aguarde"), findsOneWidget);
    });
  });
}

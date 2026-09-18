import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppButton", () {
    testWidgets("renders label text", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(label: "Test Button"),
          ),
        ),
      );

      expect(find.text("Test Button"), findsOneWidget);
    });

    testWidgets("fires onPressed callback when tapped", (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Tap Me",
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text("Tap Me"));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets("does not fire onPressed when disabled", (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Disabled",
              onPressed: null,
              isDisabled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.text("Disabled"));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets("shows loading indicator when isLoading", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Loading",
              isLoading: true,
            ),
          ),
        ),
      );

      // Should show CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Should not show label text
      expect(find.text("Loading"), findsNothing);
    });

    testWidgets("primary variant renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Primary",
              variant: AppButtonVariant.primary,
            ),
          ),
        ),
      );

      expect(find.text("Primary"), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets("secondary variant renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Secondary",
              variant: AppButtonVariant.secondary,
            ),
          ),
        ),
      );

      expect(find.text("Secondary"), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets("accent variant renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Accent",
              variant: AppButtonVariant.accent,
            ),
          ),
        ),
      );

      expect(find.text("Accent"), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets("tertiary variant renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Tertiary",
              variant: AppButtonVariant.tertiary,
            ),
          ),
        ),
      );

      expect(find.text("Tertiary"), findsOneWidget);
      // tertiary uses FilledButton.tonal
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets("ghost variant renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: "Ghost",
              variant: AppButtonVariant.ghost,
            ),
          ),
        ),
      );

      expect(find.text("Ghost"), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}

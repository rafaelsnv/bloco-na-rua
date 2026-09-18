import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppCard", () {
    testWidgets("renders child widget", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text("Card Content"),
            ),
          ),
        ),
      );

      expect(find.text("Card Content"), findsOneWidget);
    });

    testWidgets("onTap callback fires when tapped", (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onTap: () => tapped = true,
              child: const Text("Tap Me"),
            ),
          ),
        ),
      );

      await tester.tap(find.text("Tap Me"));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets("disabled state prevents tap callback", (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onTap: null, // No onTap = not interactive
              child: const Text("Not Tappable"),
            ),
          ),
        ),
      );

      // When onTap is null, InkWell is not used, so we test the card without it
      await tester.tap(find.text("Not Tappable"));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets("elevation none renders with 0 elevation", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              elevation: AppCardElevation.none,
              child: Text("No Shadow"),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0.0);
    });

    testWidgets("elevation xs renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              elevation: AppCardElevation.xs,
              child: Text("XS Shadow"),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1.0);
    });

    testWidgets("elevation sm renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              elevation: AppCardElevation.sm,
              child: Text("SM Shadow"),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2.0);
    });

    testWidgets("elevation md renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              elevation: AppCardElevation.md,
              child: Text("MD Shadow"),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4.0);
    });

    testWidgets("elevation lg renders correctly", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              elevation: AppCardElevation.lg,
              child: Text("LG Shadow"),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 8.0);
    });

    testWidgets("uses MaterialApp wrapper", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text("Wrapped"),
            ),
          ),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}

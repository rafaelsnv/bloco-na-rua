import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppSnackbar", () {
    group("success", () {
      testWidgets("displays message via ScaffoldMessenger", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.success(context, message: "Saved!"),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();

        // SnackBar appears in widget tree
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text("Saved!"), findsOneWidget);
      });

      testWidgets("applies success (green) color", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.success(context, message: "Saved!"),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, AppColors.success);
      });

      testWidgets("auto-dismisses after snackbar duration", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.success(context, message: "Auto"),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);

        // Pump frames until SnackBar disappears (auto-dismiss timer fires + close anim)
        // AppDurations.snackbar = 3000ms, close animation ~250ms
        for (int i = 0; i < 50; i++) {
          await tester.pump(const Duration(milliseconds: 100));
          if (find.byType(SnackBar).evaluate().isEmpty) break;
        }

        expect(find.byType(SnackBar), findsNothing);
      });

      testWidgets("action button is tappable and dismisses", (tester) async {
        bool actionCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.success(
                    context,
                    message: "With action",
                    actionLabel: "Undo",
                    onAction: () => actionCalled = true,
                  ),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400)); // entry anim

        expect(find.byType(SnackBar), findsOneWidget);

        // Action button (TextButton) should be in the SnackBar
        final undoButton = find.widgetWithText(TextButton, "Undo");
        expect(undoButton, findsOneWidget);

        // Directly invoke the TextButton's onPressed to verify the callback works
        final textButton = tester.widget<TextButton>(undoButton);
        expect(textButton.onPressed, isNotNull);
        textButton.onPressed!();
        await tester.pump();

        expect(actionCalled, isTrue);

        // Verify SnackBar dismisses after action (via ScaffoldMessenger)
        final messenger = ScaffoldMessenger.of(
          tester.element(find.byType(Scaffold)),
        );
        messenger.hideCurrentSnackBar();
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsNothing);
      });
    });

    group("error", () {
      testWidgets("applies error (red) color", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.error(context, message: "Failed!"),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, AppColors.error);
        expect(find.text("Failed!"), findsOneWidget);
      });
    });

    group("info", () {
      testWidgets("applies info (blue) color", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.info(context, message: "Tip here"),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, AppColors.info);
        expect(find.text("Tip here"), findsOneWidget);
      });
    });

    group("warning", () {
      testWidgets("applies warning (amber) color", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.warning(context, message: "Check!"),
                  child: const Text("Show"),
                );
              }),
            ),
          ),
        );

        await tester.tap(find.text("Show"));
        await tester.pump();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, AppColors.warning);
        expect(find.text("Check!"), findsOneWidget);
      });
    });
  });
}

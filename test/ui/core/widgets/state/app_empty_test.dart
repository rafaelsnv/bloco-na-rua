import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppEmpty", () {
    testWidgets("renders nothing by default (all optional)", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppEmpty())),
      );

      // All props are nullable; no title, message, or icon rendered
      expect(find.text("Nada por aqui"), findsNothing);
      expect(find.byIcon(Icons.inbox_outlined), findsNothing);
    });

    testWidgets("renders custom title", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmpty(title: "Sem itens")),
        ),
      );

      expect(find.text("Sem itens"), findsOneWidget);
    });

    testWidgets("renders custom message", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmpty(message: "Tente adicionar algo novo")),
        ),
      );

      expect(find.text("Tente adicionar algo novo"), findsOneWidget);
    });

    testWidgets("renders custom icon", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmpty(icon: Icons.search_off)),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsNothing);
    });

    testWidgets("renders CTA button when both actionLabel and onAction are provided", (tester) async {
      bool callbackCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmpty(
              actionLabel: "Adicionar",
              onAction: () => callbackCalled = true,
            ),
          ),
        ),
      );

      expect(find.text("Adicionar"), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      await tester.tap(find.text("Adicionar"));
      expect(callbackCalled, isTrue);
    });

    testWidgets("does not render button when only actionLabel is provided", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmpty(actionLabel: "Adicionar")),
        ),
      );

      expect(find.text("Adicionar"), findsNothing);
      expect(find.byType(Icon), findsNothing); // only the default icon
    });

    testWidgets("does not render button when only onAction is provided", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmpty(
              icon: Icons.search_off,
              onAction: () {},
            ),
          ),
        ),
      );

      // Icon shows but no button (missing actionLabel)
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      // No title text present
      expect(find.text("Nada por aqui"), findsNothing);
    });

    testWidgets("renders title and message together", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmpty(
              title: "Nada aqui",
              message: "Adicione um novo bloco",
            ),
          ),
        ),
      );

      expect(find.text("Nada aqui"), findsOneWidget);
      expect(find.text("Adicione um novo bloco"), findsOneWidget);
    });
  });
}

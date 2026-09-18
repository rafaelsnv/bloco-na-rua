import "package:bloco_na_rua/ui/core/widgets/state/app_error.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppError", () {
    testWidgets("renders with defaults", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppError())),
      );

      // Default title
      expect(find.text("Algo deu errado"), findsOneWidget);
      // Default error icon
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets("renders custom title", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppError(title: "Falha ao carregar")),
        ),
      );

      expect(find.text("Falha ao carregar"), findsOneWidget);
      expect(find.text("Algo deu errado"), findsNothing);
    });

    testWidgets("renders custom message", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppError(message: "Verifique sua conexão")),
        ),
      );

      expect(find.text("Verifique sua conexão"), findsOneWidget);
    });

    testWidgets("renders custom icon", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppError(icon: Icons.warning_amber_rounded)),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
    });

    testWidgets("renders retry button when onRetry is provided", (tester) async {
      bool callbackCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppError(
              onRetry: () => callbackCalled = true,
            ),
          ),
        ),
      );

      expect(find.text("Tentar novamente"), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

      await tester.tap(find.text("Tentar novamente"));
      expect(callbackCalled, isTrue);
    });

    testWidgets("uses custom retryLabel when provided", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppError(
              onRetry: () {},
              retryLabel: "Recarregar",
            ),
          ),
        ),
      );

      expect(find.text("Recarregar"), findsOneWidget);
      expect(find.text("Tentar novamente"), findsNothing);
    });

    testWidgets("does not render retry button when onRetry is null", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppError()),
        ),
      );

      expect(find.text("Tentar novamente"), findsNothing);
      expect(find.byIcon(Icons.refresh_rounded), findsNothing);
    });

    testWidgets("renders title and message together", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppError(
              title: "Erro de rede",
              message: "Não foi possível conectar ao servidor",
            ),
          ),
        ),
      );

      expect(find.text("Erro de rede"), findsOneWidget);
      expect(find.text("Não foi possível conectar ao servidor"), findsOneWidget);
    });
  });
}

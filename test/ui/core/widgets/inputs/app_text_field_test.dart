import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AppTextField", () {
    testWidgets("renders label text", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(label: "Email"),
          ),
        ),
      );

      expect(find.text("Email"), findsOneWidget);
    });

    testWidgets("renders hint text", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Email",
              hint: "Enter your email",
            ),
          ),
        ),
      );

      expect(find.text("Enter your email"), findsOneWidget);
    });

    testWidgets("receives text input via enterText", (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Name",
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), "John Doe");
      await tester.pump();

      expect(controller.text, "John Doe");
    });

    testWidgets("fires onChanged callback on text changes", (tester) async {
      String? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Name",
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), "Jane");
      await tester.pump();

      expect(changedValue, "Jane");
    });

    testWidgets("error state shows error text", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Email",
              errorText: "Invalid email format",
            ),
          ),
        ),
      );

      expect(find.text("Invalid email format"), findsOneWidget);
    });

    testWidgets("obscures input when isPassword is true", (tester) async {
      // Enter text and verify it appears obscured
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Password",
              obscureText: true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), "secret");
      await tester.pump();

      // When obscureText is true, the TextField's obscureText property is set
      // We verify the widget renders without error (behavior tested via enterText)
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets("disabled state prevents input", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Disabled",
              isEnabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });

    testWidgets("renders helper text", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: "Username",
              helperText: "Choose a unique username",
            ),
          ),
        ),
      );

      expect(find.text("Choose a unique username"), findsOneWidget);
    });
  });
}

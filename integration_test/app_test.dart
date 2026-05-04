// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloco_na_rua/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Screen Tests', () {
    testWidgets('App loads and shows login screen', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Bem vindo'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Login screen has email and password fields', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Find TextFormFields (email and password)
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Login screen has register link', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Não tem uma conta? Cadastre-se'), findsOneWidget);
    });

    testWidgets('Can navigate to register screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle();

      // Register screen has different text - find something specific to register
      expect(find.text('Crie sua conta'), findsOneWidget);
    });
  });

  group('Register Screen Tests', () {
    testWidgets('Register screen has name, email, password fields', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to register
      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle();

      // Should have 4 fields: nome, email, senha, confirmar senha
      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets('Register screen has Cadastrar button', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to register
      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle();

      expect(find.text('Cadastrar'), findsOneWidget);
    });
  });
}

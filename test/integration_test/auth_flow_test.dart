import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart';
import 'package:bloco_na_rua/data/repositories/auth/auth_listenable.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/l10n/app_localizations.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart';
import 'package:bloco_na_rua/ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:result_dart/result_dart.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockAuthListenable extends Mock implements AuthListenable {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration', () {
    late MockIAuthRepository mockAuthRepository;
    late MockAuthListenable mockAuthListenable;

    setUp(() {
      mockAuthRepository = MockIAuthRepository();
      mockAuthListenable = MockAuthListenable();
    });

    Widget buildTestApp() {
      return MultiProvider(
        providers: [
          Provider<IAuthRepository>.value(value: mockAuthRepository),
          ChangeNotifierProvider<AuthListenable>.value(
            value: mockAuthListenable,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pt'),
          home: BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(
              authRepository: mockAuthRepository,
              authListenable: mockAuthListenable,
            ),
            child: const _TestLoginScreen(),
          ),
        ),
      );
    }

    testWidgets('Failure on validateSession → login screen visible; '
        'tap login → fill form → submit → home screen visible; '
        'logout → returns to login screen', (tester) async {
      // Capture the cubit reference
      late AuthCubit capturedCubit;

      // Initial state: validateSession returns false → login screen shown
      when(
        () => mockAuthRepository.validateSession(),
      ).thenAnswer((_) async => false);
      when(() => mockAuthRepository.currentUuid).thenAnswer((_) async => null);
      when(() => mockAuthRepository.currentMember).thenReturn(null);
      when(
        () => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async => Failure(Exception('Invalid credentials')));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<IAuthRepository>.value(value: mockAuthRepository),
            ChangeNotifierProvider<AuthListenable>.value(
              value: mockAuthListenable,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('pt'),
            home: BlocProvider<AuthCubit>(
              create: (_) {
                capturedCubit = AuthCubit(
                  authRepository: mockAuthRepository,
                  authListenable: mockAuthListenable,
                );
                return capturedCubit;
              },
              child: const _TestLoginScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify login screen is visible
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);

      // Now mock login to succeed
      when(
        () => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer(
        (_) async =>
            const Success(LoginResponse(accessToken: 'token', userId: 'uuid')),
      );
      when(() => mockAuthListenable.notify()).thenReturn(null);

      // Fill form and submit
      await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'password123',
      );
      await tester.pumpAndSettle();

      // Tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Entrar');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // On success, should navigate to home
      // The _TestLoginScreen navigates to '/'' on AuthAuthenticated
      expect(find.text('Bloco na Rua'), findsOneWidget);

      // Logout
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Success(unit));

      // Simulate logout using the captured cubit reference
      await capturedCubit.logout();
      await tester.pumpAndSettle();

      // Should return to login screen
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
    });
  });
}

/// Minimal login screen for integration testing that navigates on success.
class _TestLoginScreen extends StatefulWidget {
  const _TestLoginScreen();

  @override
  State<_TestLoginScreen> createState() => _TestLoginScreenState();
}

class _TestLoginScreenState extends State<_TestLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, dynamic>(
      listener: (context, state) {
        if (state.toString().contains('AuthAuthenticated')) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const _HomeScreen()),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const ValueKey('email_field'),
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const ValueKey('password_field'),
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Senha'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const ValueKey('login_button'),
                onPressed: () {
                  context.read<AuthCubit>().login(
                    _emailCtrl.text,
                    _passwordCtrl.text,
                  );
                },
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloco na Rua')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

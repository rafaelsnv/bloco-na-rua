import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class FakeIAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthListenable extends Mock implements AuthListenable {}

class FakeAuthCubit extends AuthCubit {
  FakeAuthCubit()
      : super(
          authRepository: FakeIAuthRepository(),
          authListenable: FakeAuthListenable(),
        );
}

void main() {
  late FakeAuthCubit fakeAuthCubit;

  setUp(() {
    fakeAuthCubit = FakeAuthCubit();
  });

  tearDown(() {
    fakeAuthCubit.close();
  });

  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale("pt"),
      home: BlocProvider<AuthCubit>.value(
        value: fakeAuthCubit,
        child: child,
      ),
    );
  }

  group("LoginScreen", () {
    testWidgets("renders without exceptions", (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();
    });

    testWidgets("displays Entrar button", (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text("Entrar"), findsAtLeastNWidgets(1));
    });

    testWidgets("displays email and password fields", (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text("E-mail"), findsAtLeastNWidgets(1));
      expect(find.text("Senha"), findsAtLeastNWidgets(1));
    });

    testWidgets("displays forgot password link", (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text("Esqueceu a senha?"), findsOneWidget);
    });

    testWidgets("displays register link", (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text("Não tem uma conta? Cadastre-se"), findsOneWidget);
    });
  });
}

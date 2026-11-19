import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/auth/logout/widgets/logout_action.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit authCubit;

  setUp(() {
    authCubit = MockAuthCubit();
    when(() => authCubit.state).thenReturn(AuthInitial());
    when(
      () => authCubit.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
  });

  Future<void> pumpLogoutAction(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale("pt"),
        home: Scaffold(
          body: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const LogoutAction(),
          ),
        ),
      ),
    );
  }

  testWidgets("the unified logout control is the destructive button", (
    tester,
  ) async {
    await pumpLogoutAction(tester);

    expect(find.text("Sair da conta"), findsOneWidget);
  });

  testWidgets("the logout dialog uses the shared wording", (tester) async {
    await pumpLogoutAction(tester);

    await tester.tap(find.text("Sair da conta"));
    await tester.pumpAndSettle();

    // The dialog title and the button label share the same wording.
    expect(find.text("Sair da conta"), findsNWidgets(2));
    expect(
      find.text("Você precisará fazer login novamente para acessar o app."),
      findsOneWidget,
    );
    expect(find.text("Sair"), findsOneWidget);
    expect(find.text("Cancelar"), findsOneWidget);
  });
}

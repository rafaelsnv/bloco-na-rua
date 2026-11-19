// Locks in the ARB wiring of the auth, profile and settings screens.
//
// Each test renders the screen in one locale and asserts the copy comes from
// [AppLocalizations] — the Portuguese catalog in the default locale, the
// English one when the locale is overridden. A hardcoded Portuguese string
// that survived the migration would break the English case.

import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/error_types.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart";
import "package:bloco_na_rua/ui/auth/logout/widgets/logout_action.dart";
import "package:bloco_na_rua/ui/auth/signUp/widgets/signup_screen.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart";
import "package:bloco_na_rua/ui/profile/widgets/profile_screen.dart";
import "package:bloco_na_rua/ui/settings/widgets/settings_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late AuthCubit authCubit;

  setUp(() {
    authCubit = AuthCubit(
      authRepository: MockAuthRepository(),
      authListenable: AuthListenable(),
    );
  });

  tearDown(() {
    authCubit.close();
  });

  /// The app shell the screens are rendered in, in the given [locale].
  Widget appOf(Locale locale, Widget home) => MaterialApp(
    theme: AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: home,
  );

  testWidgets("the login screen renders the Portuguese catalog", (
    tester,
  ) async {
    // Arrange / Act
    await tester.pumpWidget(
      appOf(
        const Locale("pt"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    // Assert — the headline, the submit button and the recovery link all
    // come from the Portuguese catalog.
    expect(find.text("Bem vindo"), findsOneWidget);
    expect(find.text("Entre para organizar seu bloco"), findsOneWidget);
    expect(find.text("Entrar"), findsOneWidget);
    expect(find.text("Esqueceu a senha?"), findsOneWidget);
  });

  testWidgets("the login failure renders the Portuguese catalog", (
    tester,
  ) async {
    await tester.pumpWidget(
      appOf(
        const Locale("pt"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    authCubit.emit(
      const AuthFailure(
        ApiError(type: ApiErrorType.network, userMessage: "network"),
      ),
    );
    await tester.pump();

    expect(
      find.text("Sem conexão com a internet. Verifique sua rede Wi-Fi."),
      findsOneWidget,
    );
  });

  testWidgets("the login failure follows the English catalog override", (
    tester,
  ) async {
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    authCubit.emit(
      const AuthFailure(
        ApiError(type: ApiErrorType.network, userMessage: "network"),
      ),
    );
    await tester.pump();

    expect(
      find.text("No internet connection. Check your Wi-Fi."),
      findsOneWidget,
    );
  });

  testWidgets("the login screen renders the English catalog", (tester) async {
    // Arrange / Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    // Assert — the English catalog replaces the Portuguese copy.
    expect(find.text("Welcome"), findsOneWidget);
    expect(find.text("Log in to organize your block"), findsOneWidget);
    expect(find.text("Log in"), findsOneWidget);
    expect(find.text("Forgot your password?"), findsOneWidget);
    expect(find.text("Bem vindo"), findsNothing);
  });

  testWidgets("the sign-up screen renders the English catalog", (tester) async {
    // Arrange / Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const SignUpScreen(),
        ),
      ),
    );

    // Assert
    expect(find.text("Create your account"), findsOneWidget);
    expect(find.text("Sign up"), findsOneWidget);
    expect(find.text("Already have an account? Log in"), findsOneWidget);
  });

  testWidgets("the logout control renders the English catalog", (tester) async {
    // Arrange / Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LogoutAction(),
        ),
      ),
    );

    // Assert
    expect(find.text("Log out"), findsOneWidget);
  });

  testWidgets("the settings screen renders the English catalog", (
    tester,
  ) async {
    // Arrange / Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const SettingsScreen(),
        ),
      ),
    );

    // Assert — the app bar title and the account section header.
    expect(find.text("Settings"), findsOneWidget);
    expect(find.text("Account"), findsOneWidget);
    expect(find.text("Log out"), findsOneWidget);
  });

  testWidgets("the profile screen renders the English catalog", (tester) async {
    // Arrange
    final profileCubit = MockProfileCubit();
    when(() => profileCubit.state).thenReturn(
      ProfileState.loaded(
        member: MembersEntity(id: 1, name: "Ana", email: "ana@test.com"),
      ),
    );
    when(
      () => profileCubit.stream,
    ).thenAnswer((_) => const Stream<ProfileState>.empty());

    // Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: authCubit),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<ThemeCubit>.value(value: ThemeCubit()),
          ],
          child: const ProfileScreen(),
        ),
      ),
    );

    // Assert — the app bar title, the section headers and the row titles.
    expect(find.text("Profile"), findsOneWidget);
    expect(find.text("Appearance"), findsOneWidget);
    expect(find.text("Information"), findsOneWidget);
    expect(find.text("Member since"), findsOneWidget);
    expect(find.text("Perfil"), findsNothing);
  });
}

// Regression lock-in for M5 (autofill hints) and M12 (reduced motion).
//
// - M5 — the e-mail/password fields tell the platform which credential they
//   hold, and the password fields never autocorrect or suggest.
// - M12 — the onboarding page change and the FAB speed-dial skip their
//   animations when the platform asks for reduced motion.

import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart";
import "package:bloco_na_rua/ui/auth/signUp/widgets/signup_screen.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/add_block_fab.dart";
import "package:bloco_na_rua/ui/onboarding/onboarding_wrapper.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class MockAuthRepository extends Mock implements IAuthRepository {}

/// The Portuguese catalog, read straight from the ARB-generated localizations.
final AppLocalizations _pt = lookupAppLocalizations(const Locale("pt"));

/// The app shell used by every harness below.
///
/// Since the ARB/i18n migration the core widgets read their copy through
/// `AppLocalizations.of(context)!`, so a bare `MaterialApp` crashes the build
/// with a null-check error.
Widget _app({
  required Widget home,
  ThemeData? theme,
  TransitionBuilder? builder,
}) => MaterialApp(
  theme: theme ?? AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  builder: builder,
  home: home,
);

void main() {
  late MockAuthRepository authRepository;
  late AuthCubit authCubit;

  setUp(() {
    authRepository = MockAuthRepository();
    authCubit = AuthCubit(
      authRepository: authRepository,
      authListenable: AuthListenable(),
    );
  });

  tearDown(() {
    authCubit.close();
  });

  /// The editable text of the field with the given [label].
  ///
  /// [label] is the `AppTextField` key (`app_text_field_<label>`).
  EditableText field(WidgetTester tester, String label) =>
      tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(Key("app_text_field_$label")),
          matching: find.byType(EditableText),
        ),
      );

  group("M5 — the auth fields expose their autofill hints", () {
    testWidgets("M5: login announces the e-mail and the password", (
      tester,
    ) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      // Assert
      expect(
        field(tester, _pt.loginEmailLabel).autofillHints,
        contains(AutofillHints.email),
      );
      expect(
        field(tester, _pt.loginPasswordLabel).autofillHints,
        contains(AutofillHints.password),
      );
      // A password is never autocorrected or suggested.
      expect(field(tester, _pt.loginPasswordLabel).autocorrect, isFalse);
      expect(field(tester, _pt.loginPasswordLabel).enableSuggestions, isFalse);
    });

    testWidgets("M5: signup announces the e-mail and the new password", (
      tester,
    ) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const SignUpScreen(),
          ),
        ),
      );

      // Assert
      expect(
        field(tester, _pt.signupEmailLabel).autofillHints,
        contains(AutofillHints.email),
      );
      expect(
        field(tester, _pt.signupPasswordLabel).autofillHints,
        contains(AutofillHints.newPassword),
      );
      expect(field(tester, _pt.signupPasswordLabel).autocorrect, isFalse);
      expect(field(tester, _pt.signupPasswordLabel).enableSuggestions, isFalse);
    });
  });

  group("M12 — the app honours the reduced-motion setting", () {
    /// The app with reduced motion switched on.
    Widget reducedMotionApp(Widget home) => _app(
      home: home,
      theme: AppTheme.light(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!,
      ),
    );

    testWidgets("M12: the FAB speed-dial does not animate", (tester) async {
      // Arrange / Act
      await tester.pumpWidget(
        reducedMotionApp(
          Scaffold(body: AddBlockFab(isExpanded: false, onFabPressed: () {})),
        ),
      );

      // Assert — the scale and the slide happen instantly.
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale).first).duration,
        Duration.zero,
      );
      expect(
        tester.widget<AnimatedSlide>(find.byType(AnimatedSlide).first).duration,
        Duration.zero,
      );
    });

    testWidgets("M12: the onboarding page change jumps without animation", (
      tester,
    ) async {
      // Arrange — a taller surface so the onboarding art does not overflow.
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(reducedMotionApp(const OnboardingWrapper()));

      // Act — go to the second page. The button key is derived from its
      // label, which now comes from the catalog.
      await tester.tap(find.byKey(Key("app_button_${_pt.onboardingNext}")));
      await tester.pump();
      await tester.pump();

      // Assert — the second dot is already the wide (active) one, so the
      // page did not slide there.
      final dots = find.byType(AnimatedContainer);
      expect(
        tester.getSize(dots.at(1)).width,
        greaterThan(tester.getSize(dots.at(0)).width),
      );
    });
  });
}

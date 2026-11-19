// Regression lock-in for the design-system refactor on branch
// `refactor/design-system-fixes`.
//
// Each group below pins one visual finding (H1, H3, H4, H5, H6, H7). If a
// future change reintroduces the bug, the matching test fails instead of the
// UI silently breaking.
//
// House style follows the existing tests in `test/`: `flutter_test` + `test`
// only, mocktail for anything that would touch the network, and Arrange /
// Act / Assert inside every test body.

import "dart:io";
import "dart:math" as math;

import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/login/widgets/login_screen.dart";
import "package:bloco_na_rua/ui/auth/signUp/widgets/signup_screen.dart";
import "package:bloco_na_rua/ui/core/theme/app_text_colors.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/add_block_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/block_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/meeting_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_avatar.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_chip.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_icon_tile.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_logo.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_section_header.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_dropdown.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:mocktail/mocktail.dart";

// ---------------------------------------------------------------------------
// Test doubles
// ---------------------------------------------------------------------------

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockMeetingDetailsCubit extends Mock implements MeetingDetailsCubit {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// The paint transform applied to [finder]'s render box, accumulated over
/// every ancestor up to the root of the paint tree.
///
/// This is what actually reveals a rotated / scaled FAB: `tester.getSize`
/// only reports the *layout* size, which a `Transform` ancestor does not
/// change.
Matrix4 _rootTransform(WidgetTester tester, Finder finder) {
  final renderObject = tester.renderObject<RenderBox>(finder);
  return renderObject.getTransformTo(null);
}

/// Rotation (radians) encoded in [matrix]. Zero for pure translations and
/// pure scales.
double _rotationOf(Matrix4 matrix) {
  // Column-major storage: [0] = cos, [1] = sin.
  return math.atan2(matrix.storage[1], matrix.storage[0]);
}

/// True when the linear (rotation/scale) part of [matrix] is the identity.
///
/// The translation part is ignored on purpose — the FAB is positioned by its
/// parent, so only rotation and scale are interesting here.
bool _isIdentity(Matrix4 matrix) {
  // Column-major storage of the upper-left 3x3 block.
  const linearIndices = [0, 1, 2, 4, 5, 6, 8, 9, 10];
  const expected = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0];
  for (var i = 0; i < linearIndices.length; i++) {
    if ((matrix.storage[linearIndices[i]] - expected[i]).abs() > 0.0001) {
      return false;
    }
  }
  return true;
}

/// The 2D scale factor encoded in [matrix] (the length of its x/y axes).
///
/// `Matrix4.getMaxScaleOnAxis` cannot be used here: it takes the largest
/// singular value of the 3D matrix, and the z axis is always 1.0 — so a
/// 0.8 scale would still report 1.0.
double _scaleOf(Matrix4 matrix) {
  final x = math.sqrt(
    matrix.storage[0] * matrix.storage[0] +
        matrix.storage[1] * matrix.storage[1],
  );
  final y = math.sqrt(
    matrix.storage[4] * matrix.storage[4] +
        matrix.storage[5] * matrix.storage[5],
  );
  return math.max(x, y);
}

/// Every `InputDecorator` currently in the tree.
List<InputDecorator> _decorators(WidgetTester tester) =>
    tester.widgetList<InputDecorator>(find.byType(InputDecorator)).toList();

/// The error text painted by the field with the given [key], or null when
/// the field shows no error.
///
/// [key] is the `AppTextField` key (`app_text_field_<label>`).
String? _errorTextOf(WidgetTester tester, String key) {
  final decorator = tester.widget<InputDecorator>(
    find.descendant(
      of: find.byKey(Key(key)),
      matching: find.byType(InputDecorator),
    ),
  );
  return decorator.decoration.errorText;
}

/// WCAG 2.x contrast ratio between [a] and [b] (1.0 – 21.0).
///
/// `Color.computeLuminance` already implements the WCAG relative luminance
/// formula, so no hand-rolled channel linearisation is needed.
double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// The ink actually painted on a button's label.
Color _labelInk(WidgetTester tester, String label) {
  final text = tester.widget<Text>(
    find.descendant(of: find.byType(AppButton), matching: find.text(label)),
  );
  return text.style?.color ?? Colors.transparent;
}

/// The Portuguese catalog, read straight from the ARB-generated localizations.
///
/// The copy these tests assert on moved into the catalog during the ARB/i18n
/// migration, so the expectations are built from the same source the widgets
/// read from.
final AppLocalizations _pt = lookupAppLocalizations(const Locale("pt"));

/// The app shell used by every harness below.
///
/// Since the ARB/i18n migration the core widgets read their copy through
/// `AppLocalizations.of(context)!`, so a bare `MaterialApp` crashes the build
/// with a null-check error. The delegates and the explicit `pt` locale keep
/// the Portuguese copy the assertions below expect.
Widget _app({required Widget home, ThemeData? theme, Key? key}) => MaterialApp(
  key: key,
  theme: theme ?? AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  home: home,
);

void main() {
  setUpAll(() async {
    // The cards format dates with the pt_BR locale.
    await initializeDateFormatting("pt_BR", null);
  });

  // =========================================================================
  // H1 — Section headers are not double-padded
  // =========================================================================
  group("H1 — AppSectionHeader adds no horizontal padding of its own", () {
    testWidgets("H1: header title sits exactly at the caller's padding edge", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: const AppSectionHeader(title: "Aparência"),
            ),
          ),
        ),
      );

      // Act
      final titleRect = tester.getRect(find.text("Aparência"));

      // Assert — 16px of caller padding, 0px from the header itself.
      expect(titleRect.left, 16.0);
    });

    testWidgets(
      "H1: header stays flush even when a leading widget is present",
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          _app(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: const AppSectionHeader(
                  title: "Aparência",
                  leading: Icon(Icons.palette_outlined, size: 24),
                ),
              ),
            ),
          ),
        );

        // Act
        final headerRect = tester.getRect(find.byType(AppSectionHeader));

        // Assert — the header's own box starts exactly at the padding edge.
        expect(headerRect.left, 16.0);
      },
    );
  });

  // =========================================================================
  // H3 — Auth forms show no error border on the first frame
  // =========================================================================
  group("H3 — Auth forms do not validate on the first frame", () {
    late AuthCubit authCubit;
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
      authCubit = AuthCubit(
        // The screen never calls the repository on the first frame; a mock
        // keeps the test offline and deterministic.
        authRepository: authRepository,
        authListenable: AuthListenable(),
      );
    });

    tearDown(() {
      authCubit.close();
    });

    testWidgets("H3: login form shows no error border and an enabled submit", (
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

      // Assert — pristine fields carry no error state.
      final decorators = _decorators(tester);
      expect(decorators, isNotEmpty);
      for (final decorator in decorators) {
        expect(
          decorator.decoration.error,
          isNull,
          reason: "pristine field must not paint an error border",
        );
        expect(
          decorator.decoration.errorText,
          isNull,
          reason: "pristine field must not show an error message",
        );
      }

      // The submit button starts enabled: an invalid form is reported inline
      // on submit instead of a CTA that never becomes tappable (H12).
      final submit = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.loginEnterButton),
      );
      expect(submit.isDisabled, isFalse);
      expect(submit.onPressed, isNotNull);

      final filled = tester.widget<FilledButton>(
        find.byKey(Key("app_button_${_pt.loginEnterButton}")),
      );
      expect(filled.onPressed, isNotNull);
    });

    testWidgets("H3: signup form shows no error border and an enabled submit", (
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
      final decorators = _decorators(tester);
      expect(decorators, isNotEmpty);
      for (final decorator in decorators) {
        expect(decorator.decoration.error, isNull);
        expect(decorator.decoration.errorText, isNull);
      }

      final submit = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.signupSubmitButton),
      );
      expect(submit.isDisabled, isFalse);
      expect(submit.onPressed, isNotNull);
    });

    testWidgets("H3: signup errors only the field the user is editing", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const SignUpScreen(),
          ),
        ),
      );

      // Act
      await tester.enterText(
        find.byKey(Key("app_text_field_${_pt.signupEmailLabel}")),
        "not-an-email",
      );
      await tester.pump();

      // Assert — the e-mail field shows its error, every other field stays
      // neutral and the submit button stays enabled.
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.signupEmailLabel}"),
        _pt.signupEmailInvalid,
      );
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.signupNameLabel}"),
        isNull,
      );
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.signupPasswordLabel}"),
        isNull,
      );
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.signupPhoneLabel}"),
        isNull,
      );

      final submit = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.signupSubmitButton),
      );
      expect(submit.isDisabled, isFalse);
      expect(submit.onPressed, isNotNull);
    });

    testWidgets(
      "H3: an invalid e-mail DOES surface an error once the user types",
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          _app(
            home: BlocProvider<AuthCubit>.value(
              value: authCubit,
              child: const LoginScreen(),
            ),
          ),
        );

        // Act — typing marks the field as edited, so it validates itself.
        await tester.enterText(
          find.byKey(Key("app_text_field_${_pt.loginEmailLabel}")),
          "not-an-email",
        );
        await tester.pump();

        // Assert — the error now shows, so the "pristine" assertions above
        // are not vacuously true.
        final errors = _decorators(tester)
            .map((d) => d.decoration.errorText)
            .where((text) => text != null)
            .toList();
        expect(errors, isNotEmpty);
      },
    );

    testWidgets(
      "H3: typing an invalid e-mail errors only on the e-mail field",
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          _app(
            home: BlocProvider<AuthCubit>.value(
              value: authCubit,
              child: const LoginScreen(),
            ),
          ),
        );

        // Act — one character in the e-mail field.
        await tester.enterText(
          find.byKey(Key("app_text_field_${_pt.loginEmailLabel}")),
          "not-an-email",
        );
        await tester.pump();

        // Assert — the edited field shows its error, the untouched password
        // field does not, and the submit button stays enabled.
        expect(
          _errorTextOf(tester, "app_text_field_${_pt.loginEmailLabel}"),
          _pt.loginEmailInvalid,
        );
        expect(
          _errorTextOf(tester, "app_text_field_${_pt.loginPasswordLabel}"),
          isNull,
        );

        final submit = tester.widget<AppButton>(
          find.widgetWithText(AppButton, _pt.loginEnterButton),
        );
        expect(submit.isDisabled, isFalse);
        expect(submit.onPressed, isNotNull);
      },
    );

    testWidgets("H3: a valid e-mail and password enable the submit", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const LoginScreen(),
          ),
        ),
      );

      // Act
      await tester.enterText(
        find.byKey(Key("app_text_field_${_pt.loginEmailLabel}")),
        "maria@bloconarua.com.br",
      );
      await tester.enterText(
        find.byKey(Key("app_text_field_${_pt.loginPasswordLabel}")),
        "senha-secreta",
      );
      await tester.pump();

      // Assert — no error is painted and the submit button is live.
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.loginEmailLabel}"),
        isNull,
      );
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.loginPasswordLabel}"),
        isNull,
      );

      final submit = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.loginEnterButton),
      );
      expect(submit.isDisabled, isFalse);
      expect(submit.onPressed, isNotNull);
    });

    testWidgets(
      "H3: submitting an empty form shows every error and skips the API",
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          _app(
            home: BlocProvider<AuthCubit>.value(
              value: authCubit,
              child: const LoginScreen(),
            ),
          ),
        );

        // Act — the submit button is always enabled (H12): tapping it
        // validates the whole form and reports every error inline instead
        // of calling the API.
        await tester.tap(find.byKey(Key("app_button_${_pt.loginEnterButton}")));
        await tester.pump();

        // Assert — every invalid field shows its error.
        expect(
          _errorTextOf(tester, "app_text_field_${_pt.loginEmailLabel}"),
          _pt.loginEmailRequired,
        );
        expect(
          _errorTextOf(tester, "app_text_field_${_pt.loginPasswordLabel}"),
          _pt.loginPasswordRequired,
        );

        // Assert — the auth API was not called.
        verifyNever(
          () => authRepository.login(
            email: any(named: "email"),
            password: any(named: "password"),
          ),
        );
      },
    );
  });

  // =========================================================================
  // H4 / H5 — The FAB is not rotated into a diamond
  // =========================================================================
  group("H4 — the FAB rotation is scoped to the icon", () {
    testWidgets("H4: expanded FAB is not wrapped in a rotation", (
      tester,
    ) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AddBlockFab(isExpanded: true, onFabPressed: () {}),
          ),
        ),
      );

      // Assert — nothing rotates the FAB itself.
      expect(
        find.ancestor(
          of: find.byType(AppFAB),
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
        reason: "the whole FAB must not be wrapped in a RotationTransition",
      );
      expect(
        _isIdentity(_rootTransform(tester, find.byType(AppFAB))),
        isTrue,
        reason: "the FAB must not carry a rotation/scale transform",
      );

      // The rotation belongs to the icon inside the FAB.
      final icon = find.descendant(
        of: find.byType(AppFAB),
        matching: find.byIcon(Icons.add_rounded),
      );
      expect(icon, findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppFAB),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
      expect(
        _rotationOf(_rootTransform(tester, icon)),
        closeTo(math.pi / 4, 0.02),
        reason: "the icon rotates 0.125 turns (45°) when expanded",
      );
    });

    testWidgets("H4: collapsed FAB carries no rotation either", (tester) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AddBlockFab(isExpanded: false, onFabPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(_isIdentity(_rootTransform(tester, find.byType(AppFAB))), isTrue);
      final icon = find.descendant(
        of: find.byType(AppFAB),
        matching: find.byIcon(Icons.add_rounded),
      );
      expect(_rotationOf(_rootTransform(tester, icon)), closeTo(0.0, 0.001));
    });
  });

  // =========================================================================
  // H5 — The FAB meets the 48px touch target
  // =========================================================================
  group("H5 — the collapsed FAB keeps a 48px touch target", () {
    testWidgets("H5: collapsed FAB is at least 48x48 and is not scaled down", (
      tester,
    ) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AddBlockFab(isExpanded: false, onFabPressed: () {}),
          ),
        ),
      );

      // Assert — the rendered size honours the medium FAB metric.
      final size = tester.getSize(find.byType(AppFAB));
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
      expect(
        AppFabSizeMetrics.md.diameter,
        greaterThanOrEqualTo(48.0),
        reason: "the medium FAB metric is the 48px touch target",
      );

      // `getSize` reports the LAYOUT size, which a scale transform does not
      // change — so also assert the paint transform is unscaled. This is what
      // catches the old 0.8 collapse scale (48 * 0.8 = 38.4px).
      expect(
        _scaleOf(_rootTransform(tester, find.byType(AppFAB))),
        closeTo(1.0, 0.001),
      );
    });
  });

  // =========================================================================
  // H8 — The collapsed speed-dial actions are inert
  // =========================================================================
  group("H8 — the collapsed speed-dial actions are not tappable", () {
    testWidgets("H8: collapsed actions ignore pointers, the FAB stays live", (
      tester,
    ) async {
      // Arrange
      var fabPressed = false;
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AddBlockFab(
              isExpanded: false,
              onFabPressed: () => fabPressed = true,
            ),
          ),
        ),
      );

      // Assert — the scaled-down, fully transparent actions are still laid
      // out, so they have to be explicitly ignored.
      final ignores = tester.widgetList<IgnorePointer>(
        find.descendant(
          of: find.byType(AddBlockFab),
          matching: find.byType(IgnorePointer),
        ),
      );
      expect(ignores, hasLength(2));
      expect(ignores.every((ignore) => ignore.ignoring), isTrue);

      // Assert — the FAB itself still reacts to taps while collapsed.
      await tester.tap(find.byType(AppFAB));
      await tester.pump();
      expect(fabPressed, isTrue);
    });

    testWidgets("H8: expanded actions are visible and tappable", (
      tester,
    ) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AddBlockFab(isExpanded: true, onFabPressed: () {}),
          ),
        ),
      );

      // Assert — the actions are back in the hit-test path.
      final ignores = tester.widgetList<IgnorePointer>(
        find.descendant(
          of: find.byType(AddBlockFab),
          matching: find.byType(IgnorePointer),
        ),
      );
      expect(ignores, hasLength(2));
      expect(ignores.every((ignore) => !ignore.ignoring), isTrue);
      // The speed-dial labels come from the catalog.
      expect(
        find.widgetWithText(AppButton, _pt.coreFabJoinBlock),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(AppButton, _pt.coreFabCreateBlock),
        findsOneWidget,
      );

      for (final label in [_pt.coreFabJoinBlock, _pt.coreFabCreateBlock]) {
        final button = find.descendant(
          of: find.byType(AddBlockFab),
          matching: find.byKey(Key("app_button_$label")),
        );
        final textWidth = tester.getSize(find.text(label)).width;
        final expectedWidth =
            AppButtonSizeMetrics.sm.iconSize +
            AppButtonSizeMetrics.sm.iconLabelGap +
            textWidth +
            2 * AppButtonSizeMetrics.sm.horizontalPadding +
            2 * Radii.outlineWidth;
        expect(
          tester.getSize(button).width,
          lessThanOrEqualTo(expectedWidth + 1),
          reason: "speed-dial pill width must match its content and outline",
        );
      }
    });
  });

  // =========================================================================
  // H6 — The meeting status chip does not overlap the title
  // =========================================================================
  group("H6 — the meeting status chip never overlaps the meeting title", () {
    late MockMeetingDetailsCubit cubit;

    setUp(() {
      cubit = MockMeetingDetailsCubit();
    });

    testWidgets("H6: status chip rect does not intersect the title rect", (
      tester,
    ) async {
      // Arrange — a long title so the chip has to fight for horizontal space.
      const meetingName = "Encontro de Carnaval do Bloco na Rua em Recife 2026";
      final meeting = MeetingsEntity(
        id: 1,
        name: meetingName,
        description: "Encontro de abertura",
        location: "Recife - PE",
        meetingDateTime: DateTime.now().add(const Duration(days: 30)),
        carnivalBlockId: 1,
      );

      when(() => cubit.state).thenReturn(
        MeetingDetailsLoaded(
          meeting: meeting,
          blockName: "Bloco Boi da Torre",
          presencesStatus: PresencesStatus.loaded,
        ),
      );
      when(
        () => cubit.stream,
      ).thenAnswer((_) => const Stream<MeetingDetailsState>.empty());
      when(() => cubit.loadMeeting()).thenAnswer((_) async {});

      await tester.pumpWidget(
        _app(
          home: BlocProvider<MeetingDetailsCubit>.value(
            value: cubit,
            child: const MeetingDetailsScreen(meetingId: "1"),
          ),
        ),
      );
      await tester.pump();

      // Act — the title lives in the meeting info card (the app bar shows the
      // same string, so scope the lookup to the card).
      final title = find.descendant(
        of: find.byType(AppCard).first,
        matching: find.text(meetingName),
      );
      expect(title, findsOneWidget);
      final titleRect = tester.getRect(title);
      // The status chip copy comes from the catalog.
      final chip = find.widgetWithText(AppChip, _pt.meetingsStatusUpcoming);
      expect(chip, findsOneWidget);
      final chipRect = tester.getRect(chip);

      // Assert
      expect(
        titleRect.overlaps(chipRect),
        isFalse,
        reason:
            "the status chip must sit beside the title, never on top of it "
            "(the title's last character used to be clipped)",
      );
      expect(titleRect.right, lessThanOrEqualTo(chipRect.left));
    });
  });

  // =========================================================================
  // H7 — All card types share one elevation
  // =========================================================================
  group("H7 — every card type uses the same elevation", () {
    testWidgets("H7: AppCard, MeetingCard, MemberCard and BlockCard agree", (
      tester,
    ) async {
      // Arrange
      final meeting = MeetingsEntity(
        id: 1,
        name: "Encontro",
        meetingDateTime: DateTime(2026, 12, 25, 14),
      );
      final member = MembersEntity(id: 1, name: "Maria da Silva");
      final block = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: "Boi da Torre",
        inviteCode: "ABC123",
        managersInviteCode: "MGR123",
        // Empty URL -> the celebration AppIconTile placeholder, no network image.
        carnivalBlockImage: "",
      );

      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  MeetingCard(meeting: meeting),
                  MemberCard(member: member),
                  BlockCard(block: block),
                ],
              ),
            ),
          ),
        ),
      );

      // Act
      double? elevationOf(Type cardType) => tester
          .widget<Card>(
            find.descendant(
              of: find.byType(cardType),
              matching: find.byType(Card),
            ),
          )
          .elevation;

      final meetingElevation = elevationOf(MeetingCard);
      final memberElevation = elevationOf(MemberCard);
      final blockElevation = elevationOf(BlockCard);

      // Assert — one shared elevation, and it is the design-system default.
      expect(meetingElevation, AppElevation.sm.value);
      expect(memberElevation, meetingElevation);
      expect(blockElevation, meetingElevation);
      expect(
        const AppCard(child: SizedBox.shrink()).elevation,
        AppElevation.sm,
        reason: "AppCard must default to AppElevation.sm",
      );
    });
  });

  // =========================================================================
  // H9 — The accent CTA's label ink passes WCAG AA
  // =========================================================================
  group("H9 — the accent button's label ink passes WCAG AA", () {
    testWidgets(
      "H9: the enabled accent label is near-black on the orange fill",
      (tester) async {
        // Arrange / Act
        await tester.pumpWidget(
          _app(
            home: Scaffold(
              body: AppButton(
                label: "Entrar",
                variant: AppButtonVariant.accent,
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert — the ink is the near-black token, not white.
        final ink = _labelInk(tester, "Entrar");
        expect(ink, AppColors.textPrimary);

        // Assert — the label (16–18px, so AA needs 4.5:1) clears the bar.
        // #1C1917 on #D97706 ≈ 5.44:1. The old white ink was #FFFFFF on
        // #D97706 ≈ 3.19:1 — a AA failure on the primary CTA.
        final ratio = _contrastRatio(ink, AppColors.accent);
        expect(ratio, greaterThanOrEqualTo(4.5));
      },
    );

    testWidgets("H9: the enabled accent label is near-black in dark mode too", (
      tester,
    ) async {
      // Arrange / Act
      await tester.pumpWidget(
        _app(
          theme: AppTheme.dark(),
          home: Scaffold(
            body: AppButton(
              label: "Entrar",
              variant: AppButtonVariant.accent,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert — same near-black ink on the lighter dark-mode fill.
      // #1C1917 on #FBBF24 ≈ 9.53:1.
      final ink = _labelInk(tester, "Entrar");
      expect(ink, AppColors.textPrimary);
      expect(
        _contrastRatio(ink, AppColors.accentLight),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  // =========================================================================
  // H10 — The avatar initials ink passes WCAG AA on every palette fill
  // =========================================================================
  group("H10 — the avatar initials ink passes WCAG AA", () {
    // Names are plain so the initials are rendered (never the person icon),
    // and plenty of them so the hash spreads over several palette entries.
    const names = [
      "Ana",
      "Bruno",
      "Carla",
      "Diego",
      "Elisa",
      "Felipe",
      "Gabriela",
      "Henrique",
      "Isabel",
      "Joao",
      "Karina",
      "Lucas",
      "Mariana",
      "Nelson",
      "Olivia",
      "Paulo",
      "Rita",
      "Samuel",
      "Tania",
      "Vitor",
    ];

    /// Renders one avatar per name and returns the (fill, ink) pairs observed.
    Future<List<(Color, Color)>> renderPairs(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      await tester.pumpWidget(
        _app(
          theme: theme,
          home: Scaffold(
            body: Wrap(
              children: [
                for (var i = 0; i < names.length; i++)
                  AppAvatar(key: ValueKey("avatar_$i"), name: names[i]),
                // No name — the person-icon fallback, which uses the same
                // paired ink as the initials.
                const AppAvatar(key: ValueKey("avatar_icon")),
              ],
            ),
          ),
        ),
      );

      final pairs = <(Color, Color)>[];
      for (var i = 0; i < names.length; i++) {
        final avatar = find.byKey(ValueKey("avatar_$i"));
        final fill = tester
            .widget<CircleAvatar>(
              find.descendant(of: avatar, matching: find.byType(CircleAvatar)),
            )
            .backgroundColor!;
        final ink = tester
            .widget<Text>(
              find.descendant(of: avatar, matching: find.byType(Text)),
            )
            .style!
            .color!;
        pairs.add((fill, ink));
      }

      final iconAvatar = find.byKey(const ValueKey("avatar_icon"));
      pairs.add((
        tester
            .widget<CircleAvatar>(
              find.descendant(
                of: iconAvatar,
                matching: find.byType(CircleAvatar),
              ),
            )
            .backgroundColor!,
        tester
            .widget<Icon>(
              find.descendant(of: iconAvatar, matching: find.byType(Icon)),
            )
            .color!,
      ));
      return pairs;
    }

    testWidgets("H10: every avatar fill is paired with an AA ink", (
      tester,
    ) async {
      // Arrange / Act
      final pairs = await renderPairs(tester, AppTheme.light());

      // Assert — at least three distinct fills are covered, so the check
      // cannot silently pass on a single palette entry.
      final distinctFills = pairs.map((pair) => pair.$1).toSet();
      expect(
        distinctFills.length,
        greaterThanOrEqualTo(3),
        reason: "the name hash must reach several palette entries",
      );

      // Assert — each fill carries exactly one ink, and that ink clears
      // WCAG AA (4.5:1) on it. The old white-on-everything rule failed on
      // the gold (3.19:1), green (3.29:1) and cyan (2.77:1) fills.
      final inkPerFill = <Color, Set<Color>>{};
      for (final (fill, ink) in pairs) {
        (inkPerFill[fill] ??= <Color>{}).add(ink);
        expect(
          _contrastRatio(ink, fill),
          greaterThanOrEqualTo(4.5),
          reason: "ink $ink on fill $fill must clear WCAG AA",
        );
      }
      for (final entry in inkPerFill.entries) {
        expect(
          entry.value,
          hasLength(1),
          reason: "fill ${entry.key} must always use the same ink",
        );
      }
    });

    testWidgets("H10: the same holds in dark mode", (tester) async {
      // Arrange / Act
      final pairs = await renderPairs(tester, AppTheme.dark());

      // Assert — the palette is brightness-independent, so the ink that
      // passes AA on the light theme passes it in dark mode too.
      expect(pairs.map((pair) => pair.$1).toSet(), isNotEmpty);
      for (final (fill, ink) in pairs) {
        expect(
          _contrastRatio(ink, fill),
          greaterThanOrEqualTo(4.5),
          reason: "ink $ink on fill $fill must clear WCAG AA",
        );
      }
    });
  });

  // =========================================================================
  // H11 — The destructive button's label is visible and announced
  // =========================================================================
  group("H11 — the error button's label is visible on the error fill", () {
    testWidgets(
      "H11: the enabled error label is not painted in the fill colour",
      (tester) async {
        // Arrange / Act
        await tester.pumpWidget(
          _app(
            home: Scaffold(
              body: AppButton(
                label: "Sair da conta",
                variant: AppButtonVariant.error,
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {},
              ),
            ),
          ),
        );

        // Assert — the label must be painted in the ink for the error fill.
        // The fill colour itself (red on red) made the label invisible.
        final ink = _labelInk(tester, "Sair da conta");
        expect(ink, isNot(AppColors.error));
        expect(_contrastRatio(ink, AppColors.error), greaterThanOrEqualTo(4.5));

        // Assert — the leading icon inherits the same ink, so the whole
        // control reads on the error fill.
        final iconContext = tester.element(find.byIcon(Icons.logout_rounded));
        expect(
          IconTheme.of(iconContext).color,
          AppColors.inkFor(AppColors.error),
        );
      },
    );

    testWidgets("H11: the error label is announced to screen readers", (
      tester,
    ) async {
      // Arrange
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppButton(
              label: "Sair da conta",
              variant: AppButtonVariant.error,
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {},
            ),
          ),
        ),
      );

      // Act — the semantics node of the button itself.
      final node = tester.getSemantics(find.byType(FilledButton));
      final data = node.getSemanticsData();

      // Assert — the label reaches the semantics tree exactly once, and
      // the control is announced as a button.
      expect(data.label, "Sair da conta");
      expect(data.flagsCollection.isButton, isTrue);

      handle.dispose();
    });
  });

  // =========================================================================
  // H7(w0t1) — The dropdown hint meets 4.5:1 text contrast
  // =========================================================================
  group("H7 — the dropdown hint uses onSurfaceVariant", () {
    testWidgets("H7: hint ink is colorScheme.onSurfaceVariant in both modes", (
      tester,
    ) async {
      // Arrange / Act — light mode.
      await tester.pumpWidget(
        _app(
          home: const Scaffold(
            body: AppDropdown<String>(
              hint: "Selecione",
              items: [AppDropdownItem(value: "a", label: "A")],
            ),
          ),
        ),
      );
      var hint = tester.widget<Text>(find.text("Selecione"));
      var scheme = AppTheme.light().colorScheme;
      // Assert — theme-driven ink, not the old 2.5:1 textDisabled token.
      expect(hint.style?.color, scheme.onSurfaceVariant);
      expect(
        _contrastRatio(hint.style!.color!, scheme.surface),
        greaterThanOrEqualTo(4.5),
      );

      // Arrange / Act — dark mode (fresh pump so the whole tree rebuilds).
      await tester.pumpWidget(
        _app(
          key: const ValueKey("dark_app"),
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: AppDropdown<String>(
              hint: "Selecione",
              items: [AppDropdownItem(value: "a", label: "A")],
            ),
          ),
        ),
      );
      await tester.pump();
      hint = tester.widget<Text>(find.text("Selecione"));
      scheme = AppTheme.dark().colorScheme;
      expect(hint.style?.color, scheme.onSurfaceVariant);
      expect(
        _contrastRatio(hint.style!.color!, scheme.surface),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  // =========================================================================
  // H8(w0t1) — Border tokens meet 3:1 non-text contrast on their surfaces
  // =========================================================================
  group("H8 — outline tokens meet 3:1 non-text contrast", () {
    test("H8: borderLight on white and borderDark on the dark surface", () {
      // Assert — #8B7FD6 on white ≈ 3.4:1 (was #C4B5FD at 1.6:1).
      expect(
        _contrastRatio(AppColors.borderLight, AppColors.surfaceLight),
        greaterThanOrEqualTo(3.0),
      );
      // Assert — #8A94A6 on #1F2937 ≈ 4.8:1 (was #475569 at 1.9:1).
      expect(
        _contrastRatio(AppColors.borderDark, AppColors.surfaceDark),
        greaterThanOrEqualTo(3.0),
      );
    });
  });

  // =========================================================================
  // M8 — AppTextColors exposes exactly one value per role per preset
  // =========================================================================
  group("M8 — AppTextColors has no *Dark twin fields", () {
    test("M8: light and dark presets each carry a single value per role", () {
      // Assert — one value per role, resolved by the preset itself.
      expect(AppTextColors.light.textTertiary, AppColors.textTertiary);
      expect(AppTextColors.light.textDisabled, AppColors.textDisabled);
      expect(AppTextColors.dark.textTertiary, AppColors.textTertiaryDark);
      expect(AppTextColors.dark.textDisabled, AppColors.textDisabledDark);
    });
  });

  // =========================================================================
  // Audit invariants — the patterns the UI/UX audit removed stay removed
  // =========================================================================
  group("Audit invariants — the removed patterns stay removed", () {
    /// Every Dart source file under [dir], relative to the package root.
    List<File> sourcesIn(String dir) {
      final directory = Directory(dir);
      expect(directory.existsSync(), isTrue, reason: "$dir must exist");
      return directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith(".dart"))
          .toList();
    }

    /// The paths of the files under [dir] whose source contains [pattern].
    List<String> offendersIn(String dir, String pattern) => [
      for (final source in sourcesIn(dir))
        if (source.readAsStringSync().contains(pattern)) source.path,
    ];

    test(
      "routing goes through go_router, never through Navigator.pushNamed",
      () {
        // Arrange / Act
        final pushNamed = offendersIn("lib", "pushNamed");
        final pushReplacementNamed = offendersIn("lib", "pushReplacementNamed");

        // Assert — the imperative named-route API is gone.
        expect(
          pushNamed,
          isEmpty,
          reason: "use go_router (context.go / context.push) instead",
        );
        expect(
          pushReplacementNamed,
          isEmpty,
          reason: "use go_router (context.go / context.push) instead",
        );

        // Assert — the replacement is really in place, so this test cannot pass
        // vacuously on an empty tree.
        final routerCalls = [
          ...offendersIn("lib", "context.go("),
          ...offendersIn("lib", "context.push("),
        ];
        expect(routerCalls, isNotEmpty);
      },
    );

    test("the shared buttons keep the padded tap target", () {
      // Assert — no shared button shrinks its tap target below the 48dp
      // minimum.
      expect(
        offendersIn(
          "lib/ui/core/widgets/buttons",
          "MaterialTapTargetSize.shrinkWrap",
        ),
        isEmpty,
      );

      // Assert — the padded target is really in place.
      expect(
        offendersIn(
          "lib/ui/core/widgets/buttons",
          "MaterialTapTargetSize.padded",
        ),
        isNotEmpty,
      );
    });

    test("every date is formatted through the locale-aware helper", () {
      // Assert — no screen builds its own DateFormat, which is how the
      // hardcoded "pt_BR" literals got in.
      expect(offendersIn("lib/ui", "DateFormat"), isEmpty);
      expect(offendersIn("lib/ui", "pt_BR"), isEmpty);

      // Assert — the single owner of date formatting is still there.
      expect(offendersIn("lib/core", "DateFormat"), isNotEmpty);
    });

    test("the error affordance is not the alert glyph", () {
      // Assert — the removed icon stays out of the app.
      expect(offendersIn("lib", "Icons.add_alert_rounded"), isEmpty);

      // Assert — the shared error icon is the one in use.
      expect(offendersIn("lib", "Icons.error_outline_rounded"), isNotEmpty);
    });

    test("the meeting screens allocate no controller inside build()", () {
      for (final screen in sourcesIn("lib/ui/meetings")) {
        final lines = screen.readAsStringSync().split("\n");
        final buildStart = lines.indexWhere(
          (line) => line.contains("Widget build("),
        );
        // Not a widget file (a cubit, a state class) — nothing to check.
        if (buildStart == -1) continue;

        for (var i = buildStart; i < lines.length; i++) {
          expect(
            lines[i].contains("TextEditingController("),
            isFalse,
            reason:
                "${screen.path}:${i + 1} allocates a controller inside build() — "
                "own it as a field instead",
          );
        }
      }
    });
  });

  // =========================================================================
  // M9 / M10 — BlockCard uses AppIconTile placeholder and AppLogo uses high
  // =========================================================================
  group("M9/M10 — BlockCard placeholder & AppLogo quality", () {
    testWidgets(
      "M9: BlockCard renders celebration AppIconTile instead of emoji",
      (tester) async {
        final block = CarnivalBlocksEntity(
          id: 1,
          ownerId: 1,
          name: "Bloco Teste",
          inviteCode: "INV123",
          managersInviteCode: "MGR123",
          carnivalBlockImage: "",
        );

        await tester.pumpWidget(
          _app(
            home: Scaffold(body: BlockCard(block: block)),
          ),
        );

        expect(find.byType(AppIconTile), findsOneWidget);
        final tile = tester.widget<AppIconTile>(find.byType(AppIconTile));
        expect(tile.icon, Icons.celebration_rounded);
      },
    );

    testWidgets("M10: AppLogo renders Image.asset with FilterQuality.high", (
      tester,
    ) async {
      await tester.pumpWidget(_app(home: const Scaffold(body: AppLogo())));

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.filterQuality, FilterQuality.high);
    });
  });
}

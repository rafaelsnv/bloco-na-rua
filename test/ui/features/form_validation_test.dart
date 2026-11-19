// Regression lock-in for the validation unification (H2, H3, H12).
//
// Every rule the three screens share:
// - H2 — a field error is painted inline, below the field that owns it.
//   Never through a snackbar.
// - H3 — the meeting description is optional, exactly as its hint says.
// - H12 — a submit CTA is never a dead end: it stays tappable and reports
//   the invalid fields when the user submits.
//
// House style follows the existing tests in `test/`: `flutter_test` + mocktail
// for anything that would touch the network, and Arrange / Act / Assert
// inside every test body.

import "package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/widgets/create_block_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_state.dart";
import "package:bloco_na_rua/ui/carnivalBlock/editBlock/widgets/edit_block_screen.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/meetings/createMeeting/widgets/create_meeting_screen.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_cubit.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_state.dart";
import "package:bloco_na_rua/ui/meetings/editMeeting/widgets/edit_meeting_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";

// ---------------------------------------------------------------------------
// Test doubles
// ---------------------------------------------------------------------------

class MockEditBlockCubit extends Mock implements EditBlockCubit {}

class MockEditMeetingCubit extends Mock implements EditMeetingCubit {}

class MockMeetingsRepository extends Mock implements IMeetingsRepository {}

class MockCreateBlockCubit extends Mock implements CreateBlockCubit {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

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
Widget _app({required Widget home}) => MaterialApp(
  theme: AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  home: home,
);

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

/// The error text painted by the picker field with the given [label].
String? _pickerErrorTextOf(WidgetTester tester, String label) =>
    _errorTextOf(tester, "app_date_time_field_$label");

/// Fills every required field of the create-meeting form.
///
/// The date and the time are picked, not typed: the tap lands on the
/// [AppDateTimeField] trigger.
Future<void> _fillValidMeeting(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(Key("app_text_field_${_pt.meetingsTitleLabel}")),
    "Ensaio geral",
  );
  await tester.enterText(
    find.byKey(Key("app_text_field_${_pt.meetingsLocationLabel}")),
    "Praça central",
  );
  await tester.tap(
    find.byKey(Key("app_date_time_field_${_pt.meetingsDateLabel}")),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(TextButton, "OK"));
  await tester.pumpAndSettle();
  await tester.tap(
    find.byKey(Key("app_date_time_field_${_pt.meetingsTimeLabel}")),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(TextButton, "OK"));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    // The screens format dates with the pt_BR locale.
    await initializeDateFormatting("pt_BR", null);
  });

  // =========================================================================
  // H2 / H12 — The block name reports its error inline
  // =========================================================================
  group("H2 — the block name reports its error inline", () {
    late MockEditBlockCubit cubit;

    setUp(() {
      cubit = MockEditBlockCubit();
      when(() => cubit.state).thenReturn(
        const EditBlockLoaded(
          id: 1,
          name: "Boi da Torre",
          carnivalBlockImage: "",
        ),
      );
      when(
        () => cubit.stream,
      ).thenAnswer((_) => const Stream<EditBlockState>.empty());
    });

    testWidgets("H2: an empty name paints the error and does not save", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<EditBlockCubit>.value(
            value: cubit,
            child: const EditBlockScreen(carnivalBlockId: "1"),
          ),
        ),
      );
      await tester.pump();

      // Assert — the CTA is tappable even with an empty name, otherwise the
      // user could never reach the error (H12).
      final save = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.blocksSaveChanges),
      );
      expect(save.onPressed, isNotNull);

      // Act
      await tester.tap(find.byKey(Key("app_button_${_pt.blocksSaveChanges}")));
      await tester.pump();

      // Assert — the error is inline, below the field that owns it.
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.blockNameLabel}"),
        _pt.blockNameRequired,
      );
      verifyNever(
        () => cubit.updateBlock(
          name: any(named: "name"),
          carnivalBlockImage: any(named: "carnivalBlockImage"),
        ),
      );
    });
  });

  // =========================================================================
  // H2 — The meeting title reports its error inline
  // =========================================================================
  group("H2 — the meeting title reports its error inline", () {
    late MockEditMeetingCubit cubit;

    setUp(() {
      cubit = MockEditMeetingCubit();
      when(() => cubit.state).thenReturn(
        EditMeetingState(
          status: EditMeetingStatus.loaded,
          meeting: MeetingsEntity(
            id: 1,
            name: "Ensaio geral",
            location: "Recife",
          ),
        ),
      );
      when(
        () => cubit.stream,
      ).thenAnswer((_) => const Stream<EditMeetingState>.empty());
      when(() => cubit.loadMeeting(any())).thenAnswer((_) async {});
    });

    testWidgets("H2: an empty title paints the error and does not save", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<EditMeetingCubit>.value(
            value: cubit,
            child: const EditMeetingScreen(meetingId: "1"),
          ),
        ),
      );
      await tester.pump();

      // Act — clear the title and submit.
      await tester.enterText(
        find.byKey(Key("app_text_field_${_pt.meetingsTitleLabel}")),
        "",
      );
      await tester.tap(find.byKey(Key("app_button_${_pt.meetingsSaveButton}")));
      await tester.pump();

      // Assert
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.meetingsTitleLabel}"),
        _pt.meetingsEditTitleRequired,
      );
      verifyNever(() => cubit.updateMeeting(any(), any()));
    });
  });

  // =========================================================================
  // H3 — The meeting description is optional
  // =========================================================================
  group("H3 — the meeting description is optional", () {
    late MockMeetingsRepository repository;

    setUp(() {
      repository = MockMeetingsRepository();
      // The failure path keeps the test offline: no router, no other cubits.
      when(
        () => repository.create(any()),
      ).thenAnswer((_) async => Failure(Exception("boom")));
    });

    testWidgets("H3: a meeting is created without a description", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: RepositoryProvider<IMeetingsRepository>.value(
            value: repository,
            child: const CreateMeetingScreen(carnivalBlockId: "1"),
          ),
        ),
      );
      await tester.pump();

      await _fillValidMeeting(tester);

      // Act — submit without a description.
      await tester.tap(
        find.byKey(Key("app_button_${_pt.meetingsCreateButton}")),
      );
      await tester.pump();
      await tester.pump();

      // Assert — the empty description does not block the meeting.
      final data =
          verify(() => repository.create(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(data["name"], "Ensaio geral");
      expect(data["location"], "Praça central");
      expect(data["description"], "");
    });
  });

  // =========================================================================
  // H12 — The create-meeting CTA is never a dead end
  // =========================================================================
  group("H12 — the create-meeting CTA is never a dead end", () {
    late MockMeetingsRepository repository;

    setUp(() {
      repository = MockMeetingsRepository();
      // The failure path keeps the test offline: no router, no other cubits.
      when(
        () => repository.create(any()),
      ).thenAnswer((_) async => Failure(Exception("boom")));
    });

    testWidgets("H12: the create-meeting CTA is enabled on a pristine form", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: RepositoryProvider<IMeetingsRepository>.value(
            value: repository,
            child: const CreateMeetingScreen(carnivalBlockId: "1"),
          ),
        ),
      );
      await tester.pump();

      // Assert — the CTA stays tappable even with nothing filled in, so the
      // user can always reach the inline errors.
      final cta = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.meetingsCreateButton),
      );
      expect(cta.isDisabled, isFalse);
      expect(cta.onPressed, isNotNull);
    });

    testWidgets("H12: an empty meeting paints the errors and does not save", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: RepositoryProvider<IMeetingsRepository>.value(
            value: repository,
            child: const CreateMeetingScreen(carnivalBlockId: "1"),
          ),
        ),
      );
      await tester.pump();

      // Act — submit the empty form.
      await tester.tap(
        find.byKey(Key("app_button_${_pt.meetingsCreateButton}")),
      );
      await tester.pump();

      // Assert — every invalid field reports its error inline.
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.meetingsTitleLabel}"),
        _pt.meetingsTitleRequired,
      );
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.meetingsLocationLabel}"),
        _pt.meetingsLocationRequired,
      );
      expect(
        _pickerErrorTextOf(tester, _pt.meetingsDateLabel),
        _pt.meetingsSelectDate,
      );
      expect(
        _pickerErrorTextOf(tester, _pt.meetingsTimeLabel),
        _pt.meetingsSelectTime,
      );

      // Assert — nothing was saved.
      verifyNever(() => repository.create(any()));
    });

    testWidgets("H12: a complete meeting is saved", (tester) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: RepositoryProvider<IMeetingsRepository>.value(
            value: repository,
            child: const CreateMeetingScreen(carnivalBlockId: "1"),
          ),
        ),
      );
      await tester.pump();

      await _fillValidMeeting(tester);

      // Act
      await tester.tap(
        find.byKey(Key("app_button_${_pt.meetingsCreateButton}")),
      );
      await tester.pump();
      await tester.pump();

      // Assert — the meeting reached the repository with a date and a time.
      final data =
          verify(() => repository.create(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(data["name"], "Ensaio geral");
      expect(data["meetingDateTime"], isNotNull);
      expect(data["carnivalBlockId"], 1);
    });
  });

  // =========================================================================
  // H12 — The create-block CTA is never a dead end
  // =========================================================================
  group("H12 — the create-block CTA is never a dead end", () {
    late MockCreateBlockCubit cubit;

    setUp(() {
      cubit = MockCreateBlockCubit();
      when(() => cubit.state).thenReturn(CreateBlockInitial());
      when(
        () => cubit.stream,
      ).thenAnswer((_) => const Stream<CreateBlockState>.empty());
      // The mock has to answer with a future, otherwise the screen would
      // trip over a null return.
      when(() => cubit.createBlock(any())).thenAnswer((_) async {});
    });

    testWidgets("H12: the create-block CTA is enabled on a pristine form", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<CreateBlockCubit>.value(
            value: cubit,
            child: const CreateBlockScreen(),
          ),
        ),
      );
      await tester.pump();

      // Assert — the CTA stays tappable even with an empty name.
      final cta = tester.widget<AppButton>(
        find.widgetWithText(AppButton, _pt.blocksCreate),
      );
      expect(cta.isDisabled, isFalse);
      expect(cta.onPressed, isNotNull);
    });

    testWidgets("H12: an empty name paints the error and does not save", (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<CreateBlockCubit>.value(
            value: cubit,
            child: const CreateBlockScreen(),
          ),
        ),
      );
      await tester.pump();

      // Act
      await tester.tap(find.byKey(Key("app_button_${_pt.blocksCreate}")));
      await tester.pump();

      // Assert — the error is inline, below the field that owns it.
      expect(
        _errorTextOf(tester, "app_text_field_${_pt.blockNameLabel}"),
        _pt.blockNameRequired,
      );
      verifyNever(() => cubit.createBlock(any()));
    });

    testWidgets("H12: a valid name creates the block", (tester) async {
      // Arrange
      await tester.pumpWidget(
        _app(
          home: BlocProvider<CreateBlockCubit>.value(
            value: cubit,
            child: const CreateBlockScreen(),
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(
        find.byKey(Key("app_text_field_${_pt.blockNameLabel}")),
        "Boi da Torre",
      );

      // Act
      await tester.tap(find.byKey(Key("app_button_${_pt.blocksCreate}")));
      await tester.pump();

      // Assert
      verify(() => cubit.createBlock("Boi da Torre")).called(1);
    });
  });
}

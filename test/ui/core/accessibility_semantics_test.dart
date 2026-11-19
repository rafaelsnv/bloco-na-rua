// Accessibility regression lock-in for C1 — semantic labels on icon-only
// controls.
//
// Every control covered here is icon-only (or a bare gesture target), so a
// screen reader has nothing but the semantics label to announce. These tests
// fail if the label is dropped.

import "package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart";
import "package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_fab.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_icon_button.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart";
import "package:bloco_na_rua/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:mocktail/mocktail.dart";

class MockMeetingDetailsCubit extends Mock implements MeetingDetailsCubit {}

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

void main() {
  setUpAll(() async {
    // The meeting details screen formats dates with the pt_BR locale.
    await initializeDateFormatting("pt_BR", null);
  });

  group("C1 — icon-only controls expose a pt-BR label", () {
    testWidgets("AppIconButton announces its tooltip", (tester) async {
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.copy_rounded,
              tooltip: _pt.blocksCopyCode("código do bloco"),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel(_pt.blocksCopyCode("código do bloco")),
        findsOneWidget,
      );
    });

    testWidgets("AppFAB announces the create/join action", (tester) async {
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: AppFAB(icon: Icons.add_rounded, onPressed: () {}),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel(_pt.coreFabCreateOrJoinBlock),
        findsOneWidget,
      );
    });
  });

  group("C1 — the presence list announces state and action", () {
    late MockMeetingDetailsCubit cubit;

    setUp(() {
      cubit = MockMeetingDetailsCubit();
    });

    testWidgets("presence badge and member row carry pt-BR labels", (
      tester,
    ) async {
      // Arrange — one present member and one absent member.
      final member = MembersEntity(id: 7, name: "Maria da Silva");
      when(() => cubit.state).thenReturn(
        MeetingDetailsLoaded(
          meeting: MeetingsEntity(
            id: 1,
            name: "Encontro",
            meetingDateTime: DateTime(2026, 12, 25, 14),
          ),
          blockMembers: [
            CarnivalBlockMembersEntity(
              id: 1,
              carnivalBlockId: 1,
              memberId: 7,
              role: 1,
            ),
          ],
          memberEntities: {7: member},
          presences: [
            MeetingPresencesEntity(
              id: 1,
              meetingId: 1,
              memberId: 7,
              isPresent: true,
            ),
          ],
          presencesStatus: PresencesStatus.loaded,
          canManagePresence: true,
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

      // Assert — the badge announces the state and the row announces the action.
      expect(find.bySemanticsLabel(_pt.meetingsPresent), findsOneWidget);
      expect(
        find.bySemanticsLabel(_pt.meetingsMarkPresenceOf("Maria da Silva")),
        findsOneWidget,
      );
    });
  });
}

import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_state.dart";
import "package:bloco_na_rua/ui/carnivalBlock/blockList/widgets/block_list_screen.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/block_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/meeting_card.dart";
import "package:bloco_na_rua/ui/core/widgets/layout/content_width_limiter.dart";
import "package:bloco_na_rua/ui/error/widgets/error_screen.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_state.dart";
import "package:bloco_na_rua/ui/home/widgets/home_screen.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_state.dart";
import "package:bloco_na_rua/ui/meetings/userMeetings/widgets/user_meetings_screen.dart";
import "package:bloco_na_rua/ui/not_found/widgets/not_found_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:mocktail/mocktail.dart";

class MockHomeCubit extends Mock implements HomeCubit {}

class MockFabStateCubit extends Mock implements FabStateCubit {}

class MockBlockListCubit extends Mock implements BlockListCubit {}

class MockUserMeetingsCubit extends Mock implements UserMeetingsCubit {}

Future<void> _pumpAtWidth(
  WidgetTester tester, {
  required double width,
  required Widget child,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale("pt"),
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 900)),
        child: child,
      ),
    ),
  );
  await tester.pump();
}

/// The width of the content a [ContentWidthLimiter] constrains.
///
/// The limiter caps its child at [Spacing.maxContentWidth]; the screens
/// measured here pad it with [Spacing.pagePaddingMobile] on each side.
double _constrainedContentWidth(WidgetTester tester) {
  // The outermost Center under the limiter holds the screen content; the
  // ones below it belong to the buttons and the icons.
  final content = find
      .descendant(
        of: find.byType(ContentWidthLimiter),
        matching: find.byType(Center),
      )
      .first;
  return tester.getRect(content).width;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting("pt_BR", null);
  });

  group("H9 — Responsive gutters, max content width, and carousel cap", () {
    late MockHomeCubit homeCubit;
    late MockFabStateCubit fabCubit;
    late MockBlockListCubit blockListCubit;
    late MockUserMeetingsCubit userMeetingsCubit;

    final block = CarnivalBlocksEntity(
      id: 1,
      ownerId: 1,
      name: "Boi da Torre",
      inviteCode: "ABC123",
      managersInviteCode: "MGR123",
      carnivalBlockImage: "",
    );

    final meeting = MeetingsEntity(
      id: 1,
      name: "Ensaio Geral",
      meetingDateTime: DateTime(2026, 12, 25, 14),
    );

    setUp(() {
      homeCubit = MockHomeCubit();
      fabCubit = MockFabStateCubit();
      blockListCubit = MockBlockListCubit();
      userMeetingsCubit = MockUserMeetingsCubit();

      when(() => fabCubit.state).thenReturn(const FabState());
      when(
        () => fabCubit.stream,
      ).thenAnswer((_) => const Stream<FabState>.empty());

      when(() => homeCubit.loadHomeData()).thenAnswer((_) async {});
      when(
        () => homeCubit.stream,
      ).thenAnswer((_) => const Stream<HomeState>.empty());
      when(() => homeCubit.state).thenReturn(
        HomeState(
          status: HomeStatus.success,
          blocks: [block],
          meetings: [meeting],
        ),
      );

      when(() => blockListCubit.loadBlocks()).thenAnswer((_) async {});
      when(
        () => blockListCubit.stream,
      ).thenAnswer((_) => const Stream<BlockListState>.empty());
      when(() => blockListCubit.state).thenReturn(
        BlockListState(status: BlockListStatus.success, blocks: [block]),
      );

      when(() => userMeetingsCubit.loadMeetings()).thenAnswer((_) async {});
      when(
        () => userMeetingsCubit.stream,
      ).thenAnswer((_) => const Stream<UserMeetingsState>.empty());
      when(() => userMeetingsCubit.state).thenReturn(
        UserMeetingsState(
          status: UserMeetingsStatus.success,
          meetings: [meeting],
        ),
      );
    });

    testWidgets("H9: HomeScreen caps carousel card width at 320dp on tablet", (
      tester,
    ) async {
      await _pumpAtWidth(
        tester,
        width: 1024,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>.value(value: homeCubit),
            BlocProvider<FabStateCubit>.value(value: fabCubit),
          ],
          child: const HomeScreen(),
        ),
      );

      final cardSize = tester.getSize(find.byType(BlockCard));
      expect(cardSize.width, Spacing.carouselCardMaxWidth);

      // Content column is constrained to maxContentWidth (720) with
      // desktop/tablet horizontal page padding inside it.
      final meetingWidth = tester.getSize(find.byType(MeetingCard)).width;
      expect(meetingWidth, lessThanOrEqualTo(Spacing.maxContentWidth));
    });

    testWidgets(
      "H9: BlockListScreen constrains list width to maxContentWidth on tablet",
      (tester) async {
        await _pumpAtWidth(
          tester,
          width: 1024,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BlockListCubit>.value(value: blockListCubit),
              BlocProvider<FabStateCubit>.value(value: fabCubit),
            ],
            child: const BlockListScreen(),
          ),
        );

        final cardRect = tester.getRect(find.byType(BlockCard));
        expect(
          cardRect.width,
          Spacing.maxContentWidth - 2 * Spacing.pagePaddingDesktop,
        );
        expect(cardRect.left, greaterThan(Spacing.pagePaddingDesktop));
      },
    );

    testWidgets(
      "H9: UserMeetingsScreen applies responsive gutter and maxContentWidth",
      (tester) async {
        await _pumpAtWidth(
          tester,
          width: 800,
          child: BlocProvider<UserMeetingsCubit>.value(
            value: userMeetingsCubit,
            child: const UserMeetingsScreen(),
          ),
        );

        final cardRect = tester.getRect(find.byType(MeetingCard));
        expect(
          cardRect.width,
          Spacing.maxContentWidth - 2 * Spacing.pagePaddingTablet,
        );
      },
    );

    testWidgets(
      "H9: ErrorScreen and NotFoundScreen cap their content at maxContentWidth",
      (tester) async {
        await _pumpAtWidth(tester, width: 1024, child: const ErrorScreen());
        expect(
          _constrainedContentWidth(tester),
          Spacing.maxContentWidth - 2 * Spacing.pagePaddingMobile,
        );

        await _pumpAtWidth(tester, width: 1024, child: const NotFoundScreen());
        expect(
          _constrainedContentWidth(tester),
          Spacing.maxContentWidth - 2 * Spacing.pagePaddingMobile,
        );
      },
    );
  });
}

// Regression lock-in for the Wave 3 overflow fixes (H5 / H11 / L7).
//
// - H5: HomeScreen's blocks carousel is sized by its content (intrinsic) instead
//   of a pinned 90dp height, so the card grows with the text scale.
// - H11: MeetingCard (datetime row + presence chips), MemberCard (name + role
//   chip + trailing) and AppEmpty's two-button action bar wrap/flex instead of
//   overflowing on a 320dp screen or at >= 1.5x text scale.
// - L7: AppEmpty(compact: true) renders an inline block (AppIconSizes.xxl icon,
//   tight padding, no vertical centering) and is used by HomeScreen.

import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/block_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/meeting_card.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/member_card.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_empty.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_state_view.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_state.dart";
import "package:bloco_na_rua/ui/home/widgets/home_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class MockHomeCubit extends Mock implements HomeCubit {}

class MockFabStateCubit extends Mock implements FabStateCubit {}

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
/// with a null-check error.
Widget _app({required Widget home, ThemeData? theme}) => MaterialApp(
  theme: theme ?? AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale("pt"),
  home: home,
);

/// Pumps [child] inside a 320x800 viewport with [textScale] and returns the
/// layout errors (overflows) that Flutter reported while rendering it.
Future<List<String>> _pumpAndCollectErrors(
  WidgetTester tester, {
  required Widget child,
  double width = 320,
  double textScale = 1.5,
}) async {
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    errors.add(details.exceptionAsString().split("\n").first);
  };
  addTearDown(() {
    FlutterError.onError = previous;
  });

  await tester.pumpWidget(
    _app(
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 800),
          textScaler: TextScaler.linear(textScale),
        ),
        child: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
  return errors;
}

/// The horizontal carousel of HomeScreen (the page itself scrolls vertically).
SingleChildScrollView _carouselOf(WidgetTester tester) => tester
    .widgetList<SingleChildScrollView>(find.byType(SingleChildScrollView))
    .firstWhere((view) => view.scrollDirection == Axis.horizontal);

void main() {
  group("H5 — HomeScreen blocks carousel is sized by its content", () {
    late MockHomeCubit homeCubit;
    late MockFabStateCubit fabCubit;

    setUp(() {
      homeCubit = MockHomeCubit();
      fabCubit = MockFabStateCubit();
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
          blocks: [
            CarnivalBlocksEntity(
              id: 1,
              ownerId: 1,
              name: "Boi da Torre",
              inviteCode: "ABC123",
              managersInviteCode: "MGR123",
              carnivalBlockImage: "",
            ),
          ],
        ),
      );
    });

    Widget home() => MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(value: homeCubit),
        BlocProvider<FabStateCubit>.value(value: fabCubit),
      ],
      child: const HomeScreen(),
    );

    testWidgets("H5: the carousel height follows the card, not a fixed 90dp", (
      tester,
    ) async {
      // Act
      await _pumpAndCollectErrors(tester, textScale: 1.0, child: home());

      // Assert — the carousel is exactly as tall as the card it holds.
      final carousel = _carouselOf(tester);
      final carouselHeight = tester.getSize(find.byWidget(carousel)).height;
      final cardHeight = tester.getSize(find.byType(BlockCard)).height;
      expect(carouselHeight, cardHeight);
      expect(
        carouselHeight,
        isNot(90),
        reason: "the carousel must not be pinned to the old 90dp height",
      );
    });

    testWidgets("H5: the card grows with the text scale", (tester) async {
      // Act — 1.0x
      await _pumpAndCollectErrors(tester, textScale: 1.0, child: home());
      final shortScaleHeight = tester.getSize(find.byType(BlockCard)).height;

      // Act — 2.5x
      await _pumpAndCollectErrors(tester, textScale: 2.5, child: home());
      final tallScaleHeight = tester.getSize(find.byType(BlockCard)).height;

      // Assert — the card is taller, so the carousel has to be taller too.
      expect(tallScaleHeight, greaterThan(shortScaleHeight));
    });

    testWidgets("H5: HomeScreen renders the carousel without overflow", (
      tester,
    ) async {
      // Act
      final errors = await _pumpAndCollectErrors(
        tester,
        textScale: 1.5,
        child: home(),
      );

      // Assert
      expect(errors, isEmpty);
      expect(find.byType(BlockCard), findsOneWidget);
    });
  });

  group("H11 — chip and action rows wrap/flex at narrow widths", () {
    testWidgets("H11: MeetingCard presence chips wrap without overflowing", (
      tester,
    ) async {
      // Arrange
      final meeting = MeetingsEntity(
        id: 1,
        name: "Ensaio Geral de Carnaval na Rua",
        meetingDateTime: DateTime(2026, 12, 25, 14),
        location: "Praça da Independência",
      );

      // Act
      final errors = await _pumpAndCollectErrors(
        tester,
        textScale: 1.5,
        child: MeetingCard(
          meeting: meeting,
          totalPresences: 120,
          confirmedPresences: 95,
        ),
      );

      // Assert
      expect(errors, isEmpty);
      expect(find.byType(Wrap), findsOneWidget);
      // The chip copy comes from the catalog, so the expectation is built
      // the same way the widget builds it.
      expect(find.text(_pt.corePresencesCount(95, 120)), findsOneWidget);
      expect(find.text(_pt.corePresencePartial), findsOneWidget);
    });

    testWidgets(
      "H11: MemberCard role chip flexes beside long name + trailing",
      (tester) async {
        // Arrange
        final member = MembersEntity(
          id: 1,
          name: "Maria da Silva de Albuquerque",
          email: "maria.albuquerque@exemplo.com.br",
        );

        // Act
        final errors = await _pumpAndCollectErrors(
          tester,
          textScale: 1.5,
          child: MemberCard(
            member: member,
            roleLabel: "Coordenadora de Comunicação",
            trailing: const Icon(
              Icons.person_add_rounded,
              size: AppIconSizes.lg,
            ),
          ),
        );

        // Assert
        expect(errors, isEmpty);
        expect(find.text("Coordenadora de Comunicação"), findsOneWidget);
      },
    );

    testWidgets(
      "H11: AppEmpty two-button bar wraps cleanly on a 320dp screen",
      (tester) async {
        // Act
        final errors = await _pumpAndCollectErrors(
          tester,
          textScale: 1.5,
          child: AppEmpty(
            compact: true,
            message: "Nenhum bloco ainda",
            actionLabel: "Criar bloco",
            onAction: () {},
            secondaryActionLabel: "Entrar em bloco",
            onSecondaryAction: () {},
          ),
        );

        // Assert
        expect(errors, isEmpty);
        expect(find.text("Criar bloco"), findsOneWidget);
        expect(find.text("Entrar em bloco"), findsOneWidget);
      },
    );

    testWidgets("H11: an AppButton label shrinks instead of overflowing", (
      tester,
    ) async {
      // Act
      final errors = await _pumpAndCollectErrors(
        tester,
        textScale: 1.5,
        child: AppButton(label: "Entrar em bloco", onPressed: () {}),
      );

      // Assert — the label is clipped to one line, never overflowing.
      expect(errors, isEmpty);
      final label = tester.widget<Text>(find.text("Entrar em bloco"));
      expect(label.maxLines, 1);
      expect(label.overflow, TextOverflow.ellipsis);
    });
  });

  group("L7 — AppEmpty compact variant in HomeScreen", () {
    late MockHomeCubit homeCubit;
    late MockFabStateCubit fabCubit;

    setUp(() {
      homeCubit = MockHomeCubit();
      fabCubit = MockFabStateCubit();
      when(() => fabCubit.state).thenReturn(const FabState());
      when(
        () => fabCubit.stream,
      ).thenAnswer((_) => const Stream<FabState>.empty());
      when(() => homeCubit.loadHomeData()).thenAnswer((_) async {});
      when(
        () => homeCubit.stream,
      ).thenAnswer((_) => const Stream<HomeState>.empty());
    });

    testWidgets("L7: compact AppEmpty forwards compact + a capped icon size", (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        _app(
          home: const Scaffold(
            body: AppEmpty(
              compact: true,
              icon: Icons.celebration_outlined,
              message: "Nenhum bloco ainda",
            ),
          ),
        ),
      );

      // Assert
      final stateView = tester.widget<AppStateView>(find.byType(AppStateView));
      expect(stateView.compact, isTrue);
      expect(stateView.iconSize, AppIconSizes.xxl);
    });

    testWidgets(
      "L7: HomeScreen uses compact AppEmpty when sections are empty",
      (tester) async {
        // Arrange
        when(
          () => homeCubit.state,
        ).thenReturn(const HomeState(status: HomeStatus.success));

        // Act
        final errors = await _pumpAndCollectErrors(
          tester,
          textScale: 1.5,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>.value(value: homeCubit),
              BlocProvider<FabStateCubit>.value(value: fabCubit),
            ],
            child: const HomeScreen(),
          ),
        );

        // Assert
        expect(errors, isEmpty);
        final empties = tester.widgetList<AppEmpty>(find.byType(AppEmpty));
        expect(empties.length, 2);
        for (final empty in empties) {
          expect(empty.compact, isTrue);
        }
      },
    );
  });
}

// Locks in the ARB wiring of the carnivalBlock screens.
//
// Each test renders a block screen in one locale and asserts the copy comes
// from [AppLocalizations] — the Portuguese catalog in the default locale, the
// English one when the locale is overridden. A hardcoded Portuguese string
// that survived the migration would break the English case.

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart";
import "package:bloco_na_rua/ui/carnivalBlock/createBlock/widgets/create_block_screen.dart";
import "package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart";
import "package:bloco_na_rua/ui/carnivalBlock/joinBlock/widgets/join_block_modal.dart";
import "package:bloco_na_rua/ui/core/theme/app_theme.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class MockCreateBlockCubit extends Mock implements CreateBlockCubit {}

class MockJoinBlockCubit extends Mock implements JoinBlockCubit {}

void main() {
  /// The app shell the screens are rendered in, in the given [locale].
  Widget appOf(Locale locale, Widget home) => MaterialApp(
    theme: AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: home,
  );

  testWidgets("the create block screen renders the Portuguese catalog", (
    tester,
  ) async {
    // Arrange
    final cubit = MockCreateBlockCubit();
    when(() => cubit.state).thenReturn(CreateBlockInitial());
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<CreateBlockState>.empty());

    // Act
    await tester.pumpWidget(
      appOf(
        const Locale("pt"),
        BlocProvider<CreateBlockCubit>.value(
          value: cubit,
          child: const CreateBlockScreen(),
        ),
      ),
    );

    // Assert — the app bar title, the headline and the field label all come
    // from the Portuguese catalog.
    expect(find.text("Criar bloco"), findsOneWidget);
    expect(find.text("Crie seu bloco"), findsOneWidget);
    expect(find.text("Nome do bloco"), findsOneWidget);
  });

  testWidgets("the create block screen renders the English catalog", (
    tester,
  ) async {
    // Arrange
    final cubit = MockCreateBlockCubit();
    when(() => cubit.state).thenReturn(CreateBlockInitial());
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<CreateBlockState>.empty());

    // Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<CreateBlockCubit>.value(
          value: cubit,
          child: const CreateBlockScreen(),
        ),
      ),
    );

    // Assert — the English catalog replaces the Portuguese copy.
    expect(find.text("Create block"), findsOneWidget);
    expect(find.text("Create your block"), findsOneWidget);
    expect(find.text("Block name"), findsOneWidget);
    expect(find.text("Criar bloco"), findsNothing);
  });

  testWidgets("the create block screen localizes its validation error", (
    tester,
  ) async {
    // Arrange
    final cubit = MockCreateBlockCubit();
    when(() => cubit.state).thenReturn(CreateBlockInitial());
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<CreateBlockState>.empty());

    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<CreateBlockCubit>.value(
          value: cubit,
          child: const CreateBlockScreen(),
        ),
      ),
    );

    // Act — submit the form with an empty name.
    await tester.tap(find.text("Create"));
    await tester.pumpAndSettle();

    // Assert — the validator error comes from the English catalog.
    expect(find.text("Enter a name for the block"), findsOneWidget);
  });

  testWidgets("the join block screen renders the English catalog", (
    tester,
  ) async {
    // Arrange
    final cubit = MockJoinBlockCubit();
    when(() => cubit.state).thenReturn(JoinBlockInitial());
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<JoinBlockState>.empty());

    // Act
    await tester.pumpWidget(
      appOf(
        const Locale("en"),
        BlocProvider<JoinBlockCubit>.value(
          value: cubit,
          child: const JoinBlockModal(),
        ),
      ),
    );

    // Assert — the app bar title, the invite code field and the CTA.
    expect(find.text("Join a block"), findsWidgets);
    expect(find.text("Invite code"), findsOneWidget);
    expect(find.text("Join"), findsOneWidget);
    expect(find.text("Entrar em bloco"), findsNothing);
  });
}

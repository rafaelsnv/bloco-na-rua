import "package:bloc_test/bloc_test.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:test/test.dart";

void main() {
  late FabStateCubit fabStateCubit;

  setUp(() {
    fabStateCubit = FabStateCubit();
  });

  tearDown(() {
    fabStateCubit.close();
  });

  group("FabStateCubit", () {
    test("initial state is FabState with expanded=false", () {
      expect(fabStateCubit.state, const FabState(expanded: false));
      expect(fabStateCubit.state.expanded, false);
      expect(fabStateCubit.state.shouldAnimate, true);
    });

    blocTest<FabStateCubit, FabState>(
      "toggle() switches expanded from false to true",
      build: () => FabStateCubit(),
      act: (cubit) => cubit.toggle(),
      expect: () => [
        const FabState(expanded: true, shouldAnimate: true),
      ],
    );

    blocTest<FabStateCubit, FabState>(
      "toggle() switches expanded from true to false",
      build: () => FabStateCubit(),
      seed: () => const FabState(expanded: true),
      act: (cubit) => cubit.toggle(),
      expect: () => [
        const FabState(expanded: false, shouldAnimate: true),
      ],
    );

    blocTest<FabStateCubit, FabState>(
      "dismiss() sets expanded=false when expanded",
      build: () => FabStateCubit(),
      seed: () => const FabState(expanded: true, shouldAnimate: true),
      act: (cubit) => cubit.dismiss(),
      expect: () => [
        const FabState(expanded: false, shouldAnimate: true),
      ],
    );

    blocTest<FabStateCubit, FabState>(
      "dismiss(animate: false) sets expanded=false with shouldAnimate=false",
      build: () => FabStateCubit(),
      seed: () => const FabState(expanded: true, shouldAnimate: true),
      act: (cubit) => cubit.dismiss(animate: false),
      expect: () => [
        const FabState(expanded: false, shouldAnimate: false),
      ],
    );

    blocTest<FabStateCubit, FabState>(
      "dismiss() when already collapsed emits nothing",
      build: () => FabStateCubit(),
      seed: () => const FabState(expanded: false, shouldAnimate: true),
      act: (cubit) => cubit.dismiss(),
      expect: () => [],
    );
  });
}

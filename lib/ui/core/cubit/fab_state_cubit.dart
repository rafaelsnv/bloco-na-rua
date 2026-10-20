import "package:flutter_bloc/flutter_bloc.dart";
import "package:bloco_na_rua/ui/core/cubit/fab_state.dart";

/// Cubit that manages the shared FAB expansion state across all shell branches.
///
/// Lives at the [StatefulShellRoute] level so [AppShell] can observe branch
/// navigation and call [dismiss] when the user switches tabs.
class FabStateCubit extends Cubit<FabState> {
  FabStateCubit() : super(const FabState());

  void toggle() => emit(state.copyWith(expanded: !state.expanded, shouldAnimate: true));

  void dismiss({bool animate = true}) {
    if (state.expanded) emit(state.copyWith(expanded: false, shouldAnimate: animate));
  }
}

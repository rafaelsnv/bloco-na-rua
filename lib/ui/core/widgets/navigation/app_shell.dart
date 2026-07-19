import "package:bloco_na_rua/ui/core/cubit/fab_state_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "app_app_bar.dart";
import "app_bottom_nav.dart";

/// AppShell wraps a [StatefulNavigationShell] with a [Scaffold] that renders
/// the current branch's page and an [AppBottomNav].
///
/// Uses [StatefulNavigationShell.goBranch] to switch between branches without
/// losing state. When the branch changes, any expanded FAB is dismissed via
/// [FabStateCubit].
class AppShell extends StatefulWidget {
  /// Creates an [AppShell].
  ///
  /// [navigationShell] is required and must be a [StatefulNavigationShell] obtained
  /// from a [StatefulShellRoute.indexedStack] in the go_router configuration.
  ///
  /// [items] is required and must contain between 3 and 5 navigation items.
  const AppShell({
    required this.navigationShell,
    required this.items,
    this.showAppBar = true,
    super.key,
  });

  /// The [StatefulNavigationShell] provided by go_router's [StatefulShellRoute].
  ///
  /// Used to access [StatefulNavigationShell.currentIndex] and to trigger branch
  /// navigation via [StatefulNavigationShell.goBranch].
  final StatefulNavigationShell navigationShell;

  /// The list of bottom navigation items.
  ///
  /// Must contain between 3 and 5 [AppBottomNavItem] entries corresponding to
  /// the branches in the parent [StatefulShellRoute.indexedStack].
  final List<AppBottomNavItem> items;

  /// Whether to render an [AppAppBar] above the branch content.
  ///
  /// Defaults to true. When true, the app bar title is taken from
  /// `items[navigationShell.currentIndex].label`.
  final bool showAppBar;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      context.read<FabStateCubit>().dismiss(animate: false);
    }
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (widget.showAppBar)
            AppAppBar(
              title: widget.items[widget.navigationShell.currentIndex].label,
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: widget.items,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) =>
            widget.navigationShell.goBranch(index, initialLocation: false),
      ),
    );
  }
}

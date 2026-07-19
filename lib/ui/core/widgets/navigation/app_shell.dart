import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "app_app_bar.dart";
import "app_bottom_nav.dart";

/// AppShell wraps a [StatefulNavigationShell] with a [Scaffold] that renders
/// the current branch's page and an [AppBottomNav].
///
/// The [navigationShell] parameter provides access to the current branch index
/// via [StatefulNavigationShell.currentIndex] and the branch navigation method
/// [StatefulNavigationShell.goBranch].
///
/// [items] must contain 3-5 [AppBottomNavItem] entries matching the number of
/// branches in the parent [StatefulShellRoute.indexedStack].
///
/// When [showAppBar] is true (the default), an [AppAppBar] is rendered above
/// the branch content with the title taken from `items[navigationShell.currentIndex].label`.
class AppShell extends StatelessWidget {
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

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (showAppBar)
            AppAppBar(title: items[navigationShell.currentIndex].label),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: items,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) =>
            navigationShell.goBranch(index, initialLocation: false),
      ),
    );
  }
}

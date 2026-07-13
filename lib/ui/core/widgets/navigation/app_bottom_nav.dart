import "package:flutter/material.dart";

/// Represents a single navigation item in the bottom navigation bar.
///
/// [icon] is shown when the item is not selected.
/// [activeIcon] is shown when the item is selected (falls back to [icon]).
/// [label] is displayed below the icon.
/// [tooltip] is shown on long-press (optional).
class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
  });

  /// The icon to display when this item is not selected.
  final IconData icon;

  /// The icon to display when this item is selected.
  /// If null, [icon] is used as the active icon.
  final IconData? activeIcon;

  /// The label text displayed below the icon.
  final String label;

  /// Optional tooltip shown on long-press.
  final String? tooltip;
}

/// A Material 3 bottom navigation bar widget.
///
/// Uses [NavigationBar] internally with always-show labels.
/// Requires 3-5 items and provides customization for colors and behavior.
///
/// Example:
/// ```dart
/// AppBottomNav(
///   items: const [
///     AppBottomNavItem(icon: Icons.home_rounded, label: "Home"),
///     AppBottomNavItem(icon: Icons.celebration_rounded, label: "Blocks"),
///     AppBottomNavItem(icon: Icons.event_rounded, label: "Meetings"),
///     AppBottomNavItem(icon: Icons.people_rounded, label: "Members"),
///     AppBottomNavItem(icon: Icons.person_rounded, label: "Profile"),
///   ],
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
/// )
/// ```
class AppBottomNav extends StatelessWidget {
  /// Creates a bottom navigation bar.
  ///
  /// [items] must contain between 3 and 5 [AppBottomNavItem] objects.
  /// [onTap] is called when a navigation item is tapped, receiving the item index.
  const AppBottomNav({
    super.key,
    required this.items,
    this.currentIndex = 0,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedIconColor,
    this.unselectedIconColor,
  });

  /// The list of navigation items to display.
  /// Must have between 3 and 5 items.
  final List<AppBottomNavItem> items;

  /// The index of the currently selected item.
  final int currentIndex;

  /// Callback called when a navigation item is tapped.
  /// Receives the index of the tapped item.
  final ValueChanged<int> onTap;

  /// The background color of the navigation bar.
  /// Defaults to [ThemeData.colorScheme.surface].
  final Color? backgroundColor;

  /// The color of the selected item indicator.
  /// Defaults to [ThemeData.colorScheme.primaryContainer].
  final Color? indicatorColor;

  /// The color of the icon when the item is selected.
  /// Defaults to [ThemeData.colorScheme.onPrimaryContainer].
  final Color? selectedIconColor;

  /// The color of the icon when the item is not selected.
  /// Defaults to [ThemeData.colorScheme.onSurfaceVariant].
  final Color? unselectedIconColor;

  @override
  Widget build(BuildContext context) {
    assert(
      items.length <= 5 && items.length >= 3,
      "AppBottomNav requires 3-5 items",
    );

    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surface;
    final effectiveIndicatorColor =
        indicatorColor ?? theme.colorScheme.primaryContainer;
    final effectiveSelectedIconColor =
        selectedIconColor ?? theme.colorScheme.onPrimaryContainer;
    final effectiveUnselectedIconColor =
        unselectedIconColor ?? theme.colorScheme.onSurfaceVariant;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: effectiveIndicatorColor,
      backgroundColor: effectiveBackgroundColor,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon, color: effectiveUnselectedIconColor),
          selectedIcon: Icon(
            item.activeIcon ?? item.icon,
            color: effectiveSelectedIconColor,
          ),
          label: item.label,
          tooltip: item.tooltip,
        );
      }).toList(),
    );
  }
}

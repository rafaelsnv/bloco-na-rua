// lib/ui/core/widgets/cards/app_list_tile.dart
//
// A design-system-compliant list tile widget for Bloco na Rua.
//
// Wraps Material [ListTile] with design system tokens:
//   - Title uses [AppTypography.titleMedium]
//   - Subtitle uses [AppTypography.bodyMedium] with onSurfaceVariant color
//   - Padding uses [Spacing.space_sm] horizontal and [Spacing.listItemVerticalPadding] vertical
//   - Tap and long-press feedback via InkWell (built into ListTile)
//
// State behaviour:
//   - When [onTap] is null: disabled appearance via ListTile.enabled=false.
//   - Animations respect [MediaQuery.disableAnimationsOf(context)].

import "package:flutter/material.dart";

import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";

/// A design-system-compliant list tile widget.
///
/// Wraps Material [ListTile] with consistent spacing, typography, and
/// color tokens from the Bloco na Rua design system.
///
/// Example:
/// ```dart
/// AppListTile(
///   leading: AppAvatar(name: "Maria"),
///   title: "Maria Silva",
///   subtitle: "Bateria",
///   trailing: Icon(Icons.chevron_right_rounded),
///   onTap: () => navigateToMember("maria-id"),
/// )
/// ```
class AppListTile extends StatelessWidget {
  /// Creates an [AppListTile].
  ///
  /// [title] is required and displayed using [AppTypography.titleMedium].
  ///
  /// [subtitle] is optional and displayed using [AppTypography.bodyMedium]
  /// with the onSurfaceVariant color from the current [ColorScheme].
  ///
  /// [padding] defaults to `EdgeInsets.symmetric(horizontal: Spacing.space_sm,
  /// vertical: Spacing.listItemVerticalPadding)`.
  ///
  /// When [onTap] is null the widget renders in a disabled visual state.
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isThreeLine = false,
    this.padding,
  });

  /// The primary text line displayed in the list tile.
  ///
  /// Rendered using [AppTypography.titleMedium].
  final String title;

  /// Optional secondary text line displayed below the [title].
  ///
  /// Rendered using [AppTypography.bodyMedium] with the onSurfaceVariant
  /// color from the current [ColorScheme].
  final String? subtitle;

  /// Optional widget displayed before the title and subtitle.
  ///
  /// Typically an [AppAvatar] or an [Icon].
  final Widget? leading;

  /// Optional widget displayed after the title and subtitle.
  ///
  /// Typically an [Icon] such as a chevron or action icon.
  final Widget? trailing;

  /// Callback fired when the tile is tapped.
  ///
  /// When null, the tile renders in a disabled visual state.
  final VoidCallback? onTap;

  /// Callback fired when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the subtitle should span two lines.
  ///
  /// Defaults to false, meaning the subtitle is single-line.
  final bool isThreeLine;

  /// The internal padding of the list tile's content.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: Spacing.space_sm,
  /// vertical: Spacing.listItemVerticalPadding)`.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: Spacing.space_sm,
          vertical: Spacing.listItemVerticalPadding,
        );

    return ListTile(
      enabled: onTap != null,
      contentPadding: effectivePadding,
      leading: leading,
      title: Text(title, style: AppTypography.titleMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      isThreeLine: isThreeLine,
    );
  }
}

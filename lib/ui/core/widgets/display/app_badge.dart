import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_radius.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";

/// Badge size variants.
///
/// - [sm]: Smaller padding and font (horizontal: 6, vertical: 2).
/// - [md]: Default larger padding and font (horizontal: 8, vertical: 4).
enum BadgeSize { sm, md }

/// A small badge component for notification counts and status indicators.
///
/// Renders as a standalone pill when [child] is null, or as a Material 3
/// badge overlay at the top-right corner of [child].
///
/// [label] is required and defines the text displayed inside the badge.
/// [color] sets the background color (defaults to [AppColors.primary]).
/// [size] controls padding and font scale (defaults to [BadgeSize.md]).
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.color,
    this.size = BadgeSize.md,
    this.child,
  });

  /// Text content of the badge. Required.
  final String label;

  /// Custom background color. Defaults to [AppColors.primary].
  final Color? color;

  /// Size variant controlling padding and font scale. Defaults to [BadgeSize.md].
  final BadgeSize size;

  /// Optional child to wrap. When provided, renders as a Material 3 badge
  /// overlay at the top-right corner. When null, renders as a standalone pill.
  final Widget? child;

  EdgeInsets get _padding {
    switch (size) {
      case BadgeSize.sm:
        return EdgeInsets.symmetric(
          horizontal: Spacing.space_2xs,
          vertical: Spacing.space_4xs,
        );
      case BadgeSize.md:
        return EdgeInsets.symmetric(
          horizontal: Spacing.space_2xs,
          vertical: Spacing.space_3xs,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? AppColors.primary;

    if (child != null) {
      // Wrapping mode: Badge handles positioning at top-right.
      return Badge(
        label: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: backgroundColor,
        padding: _padding,
        child: child,
      );
    }

    // Standalone mode: Chip widget for pill shape.
    return Chip(
      label: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: _padding,
      shape: RoundedRectangleBorder(borderRadius: Radii.radiusXs),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

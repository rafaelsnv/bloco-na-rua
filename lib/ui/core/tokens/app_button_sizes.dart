import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";

/// Button size metrics sourced from base [Spacing] tokens — single source of
/// truth shared by [AppButton], [AppIconButton], and [AppFAB].
///
/// All three widgets use the same ladder:
///
/// | Size | Diameter/Height | Icon          |
/// | ---- | --------------- | ------------- |
/// | sm   | space_lg (32)   | space_sm (16) |
/// | md   | space_xl (48)   | space_md (24) |
/// | lg   | space_2xl (64)  | space_lg (32) |

/// AppButton size metrics.
final class AppButtonSizeMetrics {
  const AppButtonSizeMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.iconLabelGap,
  });

  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double iconLabelGap;

  /// Small: 32px height, icon 16px.
  static const sm = AppButtonSizeMetrics(
    height: Spacing.space_lg,
    horizontalPadding: Spacing.space_2xs,
    verticalPadding: Spacing.space_xs,
    iconSize: Spacing.space_sm,
    iconLabelGap: Spacing.space_2xs,
  );

  /// Medium: 48px height, icon 24px.
  static const md = AppButtonSizeMetrics(
    height: Spacing.space_xl,
    horizontalPadding: Spacing.space_xs,
    verticalPadding: Spacing.space_sm,
    iconSize: Spacing.space_md,
    iconLabelGap: Spacing.space_2xs,
  );

  /// Large: 64px height, icon 32px.
  static const lg = AppButtonSizeMetrics(
    height: Spacing.space_2xl,
    horizontalPadding: Spacing.space_sm,
    verticalPadding: Spacing.buttonPaddingVLg,
    iconSize: Spacing.space_lg,
    iconLabelGap: Spacing.space_xs,
  );
}

/// AppIconButton size metrics.
final class AppIconButtonSizeMetrics {
  const AppIconButtonSizeMetrics({
    required this.iconSize,
    required this.visualDensity,
    required this.minTouchTarget,
  });

  final double iconSize;
  final VisualDensity visualDensity;
  final double minTouchTarget;

  /// Small: 16px icon, compact density, no enforced touch target.
  static const sm = AppIconButtonSizeMetrics(
    iconSize: Spacing.space_sm,
    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    minTouchTarget: 0,
  );

  /// Medium: 24px icon, standard density, 48px min touch target (a11y).
  static const md = AppIconButtonSizeMetrics(
    iconSize: Spacing.space_md,
    visualDensity: VisualDensity.standard,
    minTouchTarget: 48,
  );

  /// Large: 32px icon, standard density, 48px min touch target (a11y).
  static const lg = AppIconButtonSizeMetrics(
    iconSize: Spacing.space_lg,
    visualDensity: VisualDensity.standard,
    minTouchTarget: 48,
  );
}

/// AppFAB size metrics.
final class AppFabSizeMetrics {
  const AppFabSizeMetrics({
    required this.diameter,
    required this.iconSize,
  });

  final double diameter;
  final double iconSize;

  /// Small: 32px diameter, 16px icon.
  static const sm = AppFabSizeMetrics(
    diameter: Spacing.space_lg,
    iconSize: Spacing.space_sm,
  );

  /// Medium: 48px diameter, 24px icon.
  static const md = AppFabSizeMetrics(
    diameter: Spacing.space_xl,
    iconSize: Spacing.space_md,
  );

  /// Large: 64px diameter, 32px icon.
  static const lg = AppFabSizeMetrics(
    diameter: Spacing.space_2xl,
    iconSize: Spacing.space_lg,
  );
}

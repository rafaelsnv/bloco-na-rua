import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_radius.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";

enum ChipVariant { filled, outlined, soft }

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.avatar,
    this.onDeleted,
    this.onPressed,
    this.variant = ChipVariant.filled,
    this.color,
  });

  final String label;
  final Widget? avatar;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;
  final ChipVariant variant;
  final Color? color;

  /// Presence chip indicating present status (success color).
  factory AppChip.presencePresent(String label) {
    return AppChip(
      label: label,
      variant: ChipVariant.soft,
      color: AppColors.success,
    );
  }

  /// Presence chip indicating absent status (error color).
  factory AppChip.presenceAbsent(String label) {
    return AppChip(
      label: label,
      variant: ChipVariant.soft,
      color: AppColors.error,
    );
  }

  /// Member role chip (primary color).
  factory AppChip.memberRole(String label) {
    return AppChip(
      label: label,
      variant: ChipVariant.filled,
      color: AppColors.primary,
    );
  }

  /// Meeting status chip (accent color).
  factory AppChip.meetingStatus(String label) {
    return AppChip(
      label: label,
      variant: ChipVariant.filled,
      color: AppColors.accent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chipTheme = Theme.of(context).chipTheme;
    final effectiveColor = color ?? AppColors.primary;

    final (foreground, background, side) = _colors(
      context,
      chipTheme,
      effectiveColor,
    );

    final labelStyle = AppTypography.labelMedium.copyWith(color: foreground);

    final chip = RawChip(
      avatar: avatar,
      label: Text(label, style: labelStyle),
      labelStyle: labelStyle,
      onPressed: onPressed,
      onDeleted: onDeleted,
      deleteIcon: onDeleted != null
          ? Icon(
              Icons.close_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
      backgroundColor: background,
      deleteIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
      side: side,
      shape: RoundedRectangleBorder(borderRadius: Radii.chip),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.space_xs,
        vertical: Spacing.space_4xs,
      ),
      showCheckmark: false,
      // Always enabled: RawChip paints label/avatar at 38% opacity and drops
      // the background when isEnabled is false (chip.dart `_kDisabledAlpha`).
      // Display-only chips have no callbacks but must still render at full
      // strength, so interactivity is driven by onPressed/onDeleted alone.
      isEnabled: true,
    );

    return chip;
  }

  (Color, Color, BorderSide) _colors(
    BuildContext context,
    ChipThemeData chipTheme,
    Color effectiveColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case ChipVariant.filled:
        // Filled: in dark mode the brand primary chip swaps to lighter
        // equivalents (primaryLight background + primaryDark text), mirroring
        // the mockup (line 373: dark Todos chip). The dark scheme encodes this
        // swap: primary = primaryLight, primaryContainer = primaryDark.
        if (isDark && effectiveColor == AppColors.primary) {
          return (
            colorScheme.primaryContainer,
            colorScheme.primary,
            BorderSide.none,
          );
        }
        // Foreground picked by fill luminance so light fills (e.g. warning)
        // get dark text while saturated fills keep white text — readable in
        // both brightness modes. These ink colors are brightness-independent
        // (a light fill always wants dark ink, even in dark mode), so they
        // have no colorScheme equivalent — onSurface/onPrimary flip with
        // brightness and would break contrast here.
        final foreground = effectiveColor.computeLuminance() > 0.4
            ? AppColors.textPrimary
            : AppColors.textOnPrimary;
        return (foreground, effectiveColor, BorderSide.none);

      case ChipVariant.outlined:
        // Outlined: transparent background, colored border and text
        final foreground = effectiveColor;
        final background = Colors.transparent;
        final side = BorderSide(color: effectiveColor, width: 1.5);
        return (foreground, background, side);

      case ChipVariant.soft:
        // Soft: low-alpha colored background, colored text.
        // Foreground swaps to the lighter variant in dark mode and the darker
        // variant in light mode for proper contrast on the 20% opacity
        // background. Colors without dedicated light/dark tokens
        // (success/info) keep the base color.
        final foreground = _softForeground(effectiveColor, isDark, colorScheme);
        // Background always uses the effective (input) color at 20% opacity,
        // not the swapped foreground — this matches the mockup's
        // `bg-secondary/20` (mockup line 254).
        final background = effectiveColor.withValues(alpha: 0.20);
        final side = BorderSide.none;
        return (foreground, background, side);
    }
  }

  /// Soft-variant foreground: light variant in dark mode, dark variant in
  /// light mode. Warning maps to the amber accent family (no dedicated
  /// warning light/dark tokens exist).
  ///
  /// Primary/secondary/error resolve through the theme's colorScheme, which
  /// already encodes the brightness-specific variants:
  /// - dark:  primary=primaryLight, secondary=secondaryLight, error=errorDark
  /// - light: onPrimaryContainer=primaryDark, onSecondaryContainer=secondaryDark,
  ///          error=error
  /// Accent and tertiary light/dark variants are not represented in the
  /// colorScheme, so they keep their AppColors tokens.
  Color _softForeground(
    Color color,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    if (color == AppColors.primary) {
      return isDark ? colorScheme.primary : colorScheme.onPrimaryContainer;
    }
    if (color == AppColors.secondary) {
      return isDark ? colorScheme.secondary : colorScheme.onSecondaryContainer;
    }
    if (color == AppColors.accent || color == AppColors.warning) {
      return isDark ? AppColors.accentLight : AppColors.accentDark;
    }
    if (color == AppColors.tertiary) {
      return isDark ? AppColors.tertiaryLight : AppColors.tertiaryDark;
    }
    if (color == AppColors.error) {
      return colorScheme.error;
    }
    return color;
  }
}

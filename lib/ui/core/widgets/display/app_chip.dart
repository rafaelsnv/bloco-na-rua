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

  /// Meeting status chip (cta color).
  factory AppChip.meetingStatus(String label) {
    return AppChip(
      label: label,
      variant: ChipVariant.filled,
      color: AppColors.cta,
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
              color: AppColors.textSecondaryLight,
            )
          : null,
      backgroundColor: background,
      deleteIconColor: AppColors.textSecondaryLight,
      side: side,
      shape: RoundedRectangleBorder(borderRadius: Radii.chip),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.space_xs,
        vertical: Spacing.space_4xs,
      ),
      showCheckmark: false,
      isEnabled: onPressed != null || onDeleted != null,
    );

    return chip;
  }

  (Color, Color, BorderSide) _colors(
    BuildContext context,
    ChipThemeData chipTheme,
    Color effectiveColor,
  ) {
    switch (variant) {
      case ChipVariant.filled:
        // Filled: colored background, white foreground
        return (Colors.white, effectiveColor, BorderSide.none);

      case ChipVariant.outlined:
        // Outlined: transparent background, colored border and text
        final foreground = effectiveColor;
        final background = Colors.transparent;
        final side = BorderSide(color: effectiveColor, width: 1.5);
        return (foreground, background, side);

      case ChipVariant.soft:
        // Soft: low-alpha colored background, colored text
        final foreground = effectiveColor;
        final background = effectiveColor.withValues(alpha: 0.15);
        final side = BorderSide.none;
        return (foreground, background, side);
    }
  }
}

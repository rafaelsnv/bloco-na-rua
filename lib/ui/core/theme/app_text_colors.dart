import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";

/// Theme-aware text colors that are not represented by [ColorScheme].
///
/// The light and dark presets expose the same semantic roles for widgets that
/// need to choose a color explicitly while keeping the raw values in
/// [AppColors].
@immutable
class AppTextColors extends ThemeExtension<AppTextColors> {
  const AppTextColors({
    required this.textTertiary,
    required this.textDisabled,
    required this.info,
  });

  /// Tertiary text color for the active theme.
  final Color textTertiary;

  /// Disabled text color for the active theme.
  final Color textDisabled;

  /// Ink for the "info" role on the active theme's surface.
  ///
  /// A deeper cyan in light mode and a lighter cyan in dark mode, so a
  /// heading painted with it reads in both brightness modes.
  final Color info;

  /// Text colors used by the light theme.
  static const AppTextColors light = AppTextColors(
    textTertiary: AppColors.textTertiary,
    textDisabled: AppColors.textDisabled,
    info: AppColors.infoHeadingLight,
  );

  /// Text colors used by the dark theme.
  static const AppTextColors dark = AppTextColors(
    textTertiary: AppColors.textTertiaryDark,
    textDisabled: AppColors.textDisabledDark,
    info: AppColors.infoHeadingDark,
  );

  @override
  AppTextColors copyWith({
    Color? textTertiary,
    Color? textDisabled,
    Color? info,
  }) {
    return AppTextColors(
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      info: info ?? this.info,
    );
  }

  @override
  AppTextColors lerp(covariant AppTextColors? other, double t) {
    if (other == null) return this;

    return AppTextColors(
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

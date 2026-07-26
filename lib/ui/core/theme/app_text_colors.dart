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
    required this.textTertiaryDark,
    required this.textDisabledDark,
  });

  /// Tertiary text color for light surfaces.
  final Color textTertiary;

  /// Disabled text color for the active theme.
  final Color textDisabled;

  /// Tertiary text color for dark surfaces.
  final Color textTertiaryDark;

  /// Disabled text color for dark surfaces.
  final Color textDisabledDark;

  /// Text colors used by the light theme.
  static const AppTextColors light = AppTextColors(
    textTertiary: AppColors.textTertiary,
    textDisabled: AppColors.textDisabled,
    textTertiaryDark: AppColors.textTertiaryDark,
    textDisabledDark: AppColors.textDisabledDark,
  );

  /// Text colors used by the dark theme.
  static const AppTextColors dark = AppTextColors(
    textTertiary: AppColors.textTertiaryDark,
    textDisabled: AppColors.textDisabledDark,
    textTertiaryDark: AppColors.textTertiaryDark,
    textDisabledDark: AppColors.textDisabledDark,
  );

  @override
  AppTextColors copyWith({
    Color? textTertiary,
    Color? textDisabled,
    Color? textTertiaryDark,
    Color? textDisabledDark,
  }) {
    return AppTextColors(
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textTertiaryDark: textTertiaryDark ?? this.textTertiaryDark,
      textDisabledDark: textDisabledDark ?? this.textDisabledDark,
    );
  }

  @override
  AppTextColors lerp(covariant AppTextColors? other, double t) {
    if (other == null) return this;

    return AppTextColors(
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textTertiaryDark: Color.lerp(
        textTertiaryDark,
        other.textTertiaryDark,
        t,
      )!,
      textDisabledDark: Color.lerp(
        textDisabledDark,
        other.textDisabledDark,
        t,
      )!,
    );
  }
}

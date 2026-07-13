import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

/// Builds a [TextTheme] by wrapping each [AppTypography] getter in a
/// [AppTypography.xxx.copyWith] call that injects [textColor] as the
/// foreground color.
///
/// [textColor] is applied to all text styles as the foreground color,
/// providing consistent onSurface text color per brightness.
TextTheme _buildTextTheme({required Color textColor}) {
  return TextTheme(
    displayLarge: AppTypography.displayLarge.copyWith(color: textColor),
    displayMedium: AppTypography.displayMedium.copyWith(color: textColor),
    displaySmall: AppTypography.displaySmall.copyWith(color: textColor),
    headlineLarge: AppTypography.headlineLarge.copyWith(color: textColor),
    headlineMedium: AppTypography.headlineMedium.copyWith(color: textColor),
    headlineSmall: AppTypography.headlineSmall.copyWith(color: textColor),
    titleLarge: AppTypography.titleLarge.copyWith(color: textColor),
    titleMedium: AppTypography.titleMedium.copyWith(color: textColor),
    titleSmall: AppTypography.titleSmall.copyWith(color: textColor),
    bodyLarge: AppTypography.bodyLarge.copyWith(color: textColor),
    bodyMedium: AppTypography.bodyMedium.copyWith(color: textColor),
    bodySmall: AppTypography.bodySmall.copyWith(color: textColor),
    labelLarge: AppTypography.labelLarge.copyWith(color: textColor),
    labelMedium: AppTypography.labelMedium.copyWith(color: textColor),
    labelSmall: AppTypography.labelSmall.copyWith(color: textColor),
  );
}

/// Light-mode [TextTheme] using [AppColors.textPrimaryLight] as the
/// onSurface text color.
final TextTheme lightTextTheme = _buildTextTheme(
  textColor: AppColors.textPrimaryLight,
);

/// Dark-mode [TextTheme] using [AppColors.textPrimaryDark] as the
/// onSurface text color.
final TextTheme darkTextTheme = _buildTextTheme(
  textColor: AppColors.textPrimaryDark,
);

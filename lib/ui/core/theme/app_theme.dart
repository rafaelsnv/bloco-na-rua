import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/theme/app_color_schemes.dart";
import "package:bloco_na_rua/ui/core/theme/app_text_themes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

class AppTheme {
  AppTheme._();

  /// Light theme built with Material 3 and the project ColorScheme and TextTheme.
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      textTheme: lightTextTheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: lightTextTheme.headlineMedium?.copyWith(
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightColorScheme.surface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.card,
          side: BorderSide(color: lightColorScheme.outline, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(color: lightColorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: lightColorScheme.primary),
      ),
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium.copyWith(
          color: lightColorScheme.onSurface,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.space_xs,
          vertical: Spacing.space_4xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.chip),
        selectedColor: AppColors.primary,
        backgroundColor: Colors.transparent,
        checkmarkColor: lightColorScheme.onPrimary,
        secondarySelectedColor: AppColors.primary,
        side: BorderSide(color: Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: lightColorScheme.primary,
        linearTrackColor: lightColorScheme.surfaceContainerHighest,
        circularTrackColor: lightColorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: lightColorScheme.onInverseSurface,
        ),
        actionTextColor: lightColorScheme.inversePrimary,
        disabledActionTextColor: lightColorScheme.onInverseSurface.withValues(
          alpha: 0.5,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: Radii.button),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: lightColorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_md,
          vertical: Spacing.space_sm,
        ),
      ),
      iconTheme: IconThemeData(color: lightColorScheme.onSurfaceVariant),
      dividerTheme: DividerThemeData(
        color: lightColorScheme.outline,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark theme built with Material 3 and the project ColorScheme and TextTheme.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      textTheme: darkTextTheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: darkTextTheme.headlineMedium,
      ),
      cardTheme: CardThemeData(
        color: darkColorScheme.surface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.card,
          side: BorderSide(color: darkColorScheme.outline, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(color: darkColorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: darkColorScheme.primary),
      ),
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium.copyWith(
          color: darkColorScheme.onSurface,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.space_xs,
          vertical: Spacing.space_4xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.chip),
        selectedColor: AppColors.primaryLight,
        backgroundColor: Colors.transparent,
        checkmarkColor: darkColorScheme.onPrimary,
        secondarySelectedColor: AppColors.primaryLight,
        side: BorderSide(color: Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: darkColorScheme.primary,
        linearTrackColor: darkColorScheme.surfaceContainerHighest,
        circularTrackColor: darkColorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: darkColorScheme.onInverseSurface,
        ),
        actionTextColor: darkColorScheme.inversePrimary,
        disabledActionTextColor: darkColorScheme.onInverseSurface.withValues(
          alpha: 0.5,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: Radii.button),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: darkColorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_md,
          vertical: Spacing.space_sm,
        ),
      ),
      iconTheme: IconThemeData(color: darkColorScheme.onSurfaceVariant),
      dividerTheme: DividerThemeData(
        color: darkColorScheme.outline,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

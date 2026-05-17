import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

/// Light Theme for BlocoNaRua
///
/// Built from Figma Material 3 design tokens.
class LightTheme {
  LightTheme._();

  static const Color _onSurface = AppColors.onSurface;

  static ColorScheme get colorScheme => const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    inversePrimary: AppColors.inversePrimary,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      color: _onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      color: _onSurface,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: _onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
      color: _onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
      color: _onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
      color: _onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.27,
      color: _onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.15,
      height: 1.50,
      color: _onSurface,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      height: 1.43,
      color: _onSurface,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      height: 1.43,
      color: _onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.33,
      color: _onSurface,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.45,
      color: _onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      height: 1.50,
      color: _onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: _onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Lekton',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: _onSurface,
    ),
  );

  static CardThemeData get cardTheme => CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
    ),
    color: AppColors.surfaceContainerLowest,
  );

  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      );

  static OutlinedButtonThemeData get outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outline),
        ),
      );

  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: AppColors.primary,
    ),
  );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
    hintStyle: TextStyle(
      color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
    ),
  );

  static ChipThemeData get chipTheme => ChipThemeData(
    elevation: 0,
    pressElevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.outlineVariant),
    ),
    backgroundColor: AppColors.surfaceContainerLow,
    labelStyle: const TextStyle(
      fontFamily: 'Lekton',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
  );

  static FloatingActionButtonThemeData get floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: CircleBorder(),
      );

  static DividerThemeData get dividerTheme => const DividerThemeData(
    space: 1,
    thickness: 1,
    color: AppColors.outlineVariant,
  );

  static ThemeData toThemeData() => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    cardTheme: cardTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    chipTheme: chipTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    dividerTheme: dividerTheme,
  );
}

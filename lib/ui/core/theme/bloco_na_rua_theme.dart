import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

/// BlocoNaRua Theme
///
/// Central access point for light/dark ThemeData built from Figma Material 3 tokens.
/// Color constants are modularized in [AppColors].
class BlocoNaRuaTheme {
  BlocoNaRuaTheme._();

  // Re-export role colors for backward compatibility
  static const Color adminColor = AppColors.admin;
  static const Color successColor = AppColors.success;
  static const Color infoColor = AppColors.info;
  static const Color warningColor = AppColors.warning;

  static ThemeData get lightTheme => LightTheme.toThemeData();
  static ThemeData get darkTheme => DarkTheme.toThemeData();
}

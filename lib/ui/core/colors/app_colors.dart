import 'package:flutter/material.dart';

/// App Colors — Figma Material 3 Design Tokens
///
/// Modularized color constants extracted from Figma design system.
/// Organized by: Light tokens, Dark tokens, Role-based semantics.
class AppColors {
  AppColors._();

  // ============================================================
  // LIGHT THEME TOKENS
  // ============================================================

  // Primary (Figma mint green #5FDBBA)
  static const Color primary = Color(0xFF5FDBBA);
  static const Color onPrimary = Color(0xFF00382D);
  static const Color primaryContainer = Color(0xFF8CF5D5);
  static const Color onPrimaryContainer = Color(0xFF00201A);

  // Secondary
  static const Color secondary = Color(0xFF4B635B);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCDE8DF);
  static const Color onSecondaryContainer = Color(0xFF072019);

  // Tertiary
  static const Color tertiary = Color(0xFFB02F00);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFDAD3);
  static const Color onTertiaryContainer = Color(0xFF3B0400);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // Surface
  static const Color surface = Color(0xFFF5FBF7);
  static const Color onSurface = Color(0xFF16231D);
  static const Color surfaceVariant = Color(0xFFDBE5DE);
  static const Color onSurfaceVariant = Color(0xFF3F4943);

  // Outline
  static const Color outline = Color(0xFF6F7972);
  static const Color outlineVariant = Color(0xFFBFC9C1);

  // Background
  static const Color background = Color(0xFFF5FBF7);
  static const Color onBackground = Color(0xFF16231D);

  // Inverse
  static const Color inverseSurface = Color(0xFF2B332C);
  static const Color onInverseSurface = Color(0xFFECEFEC);
  static const Color inversePrimary = Color(0xFF6DD9BB);

  // Shadow & scrim
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Surface containers (light)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F7F2);
  static const Color surfaceContainer = Color(0xFFECF1ED);
  static const Color surfaceContainerHigh = Color(0xFFE6EBE7);
  static const Color surfaceContainerHighest = Color(0xFFE0E6E2);

  // ============================================================
  // DARK THEME TOKENS
  // ============================================================

  static const Color primaryDark = Color(0xFF5FDBBA);
  static const Color onPrimaryDark = Color(0xFF00382D);
  static const Color primaryContainerDark = Color(0xFF005143);
  static const Color onPrimaryContainerDark = Color(0xFF8CF5D5);

  static const Color secondaryDark = Color(0xFFB1CCC1);
  static const Color onSecondaryDark = Color(0xFF1C352D);
  static const Color secondaryContainerDark = Color(0xFF334B43);
  static const Color onSecondaryContainerDark = Color(0xFFCDE8DF);

  static const Color tertiaryDark = Color(0xFFFFB4A1);
  static const Color onTertiaryDark = Color(0xFF5F1400);
  static const Color tertiaryContainerDark = Color(0xFF7F1E00);
  static const Color onTertiaryContainerDark = Color(0xFFFFDAD3);

  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color surfaceDark = Color(0xFF1C1B1F);
  static const Color onSurfaceDark = Color(0xFFDEE9E3);
  static const Color surfaceVariantDark = Color(0xFF1C1B1F);
  static const Color onSurfaceVariantDark = Color(0xFFBFC9C1);

  static const Color outlineDark = Color(0xFF89938D);
  static const Color outlineVariantDark = Color(0xFF44474F);

  static const Color backgroundDark = Color(0xFF1C1B1F);
  static const Color onBackgroundDark = Color(0xFFDEE9E3);

  static const Color inverseSurfaceDark = Color(0xFFDEE9E3);
  static const Color onInverseSurfaceDark = Color(0xFF2B332C);
  static const Color inversePrimaryDark = Color(0xFF006B56);

  static const Color surfaceContainerLowestDark = Color(0xFF0A1510);
  static const Color surfaceContainerLowDark = Color(0xFF141F1A);
  static const Color surfaceContainerDark = Color(0xFF19231F);
  static const Color surfaceContainerHighDark = Color(0xFF232D29);
  static const Color surfaceContainerHighestDark = Color(0xFF2E3834);

  // ============================================================
  // ROLE-BASED SEMANTIC COLORS
  // ============================================================

  /// Admin role — amber.shade600
  static const Color admin = Color(0xFFFFB300);

  /// Success/present — green.shade600
  static const Color success = Color(0xFF388E3C);

  /// Info/neutral — blue.shade600
  static const Color info = Color(0xFF1976D2);

  /// Warning/late — orange.shade800
  static const Color warning = Color(0xFFE65100);
}

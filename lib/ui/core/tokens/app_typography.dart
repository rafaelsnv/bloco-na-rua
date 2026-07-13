// lib/ui/core/tokens/app_typography.dart
//
// Single source of truth for all typography styles in the Bloco na Rua
// design system. Uses GoogleFonts for Fredoka (headings) and Nunito (body).
//
// Headings: Fredoka — playful, rounded, friendly (displayLarge through headlineSmall)
// Body/Labels: Nunito — clean, readable, warm (titleLarge through labelSmall)

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTypography {
  AppTypography._();

/// Fredoka w700, 57px, lineHeight 64/57, letterSpacing -0.25
  static TextStyle get displayLarge => GoogleFonts.fredoka(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 64 / 57,
  );

  /// Fredoka w600, 45px, lineHeight 52/45, letterSpacing 0
  static TextStyle get displayMedium => GoogleFonts.fredoka(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 52 / 45,
  );

  /// Fredoka w600, 36px, lineHeight 44/36, letterSpacing 0
  static TextStyle get displaySmall => GoogleFonts.fredoka(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 44 / 36,
  );

  /// Fredoka w600, 32px, lineHeight 40/32, letterSpacing 0
  static TextStyle get headlineLarge => GoogleFonts.fredoka(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 40 / 32,
  );

  /// Fredoka w500, 28px, lineHeight 36/28, letterSpacing 0
  static TextStyle get headlineMedium => GoogleFonts.fredoka(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 36 / 28,
  );

  /// Fredoka w500, 24px, lineHeight 32/24, letterSpacing 0
  static TextStyle get headlineSmall => GoogleFonts.fredoka(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 32 / 24,
  );

/// Nunito w600, 22px, lineHeight 28/22, letterSpacing 0
  static TextStyle get titleLarge => GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 28 / 22,
  );

  /// Nunito w600, 16px, lineHeight 24/16, letterSpacing 0.15
  static TextStyle get titleMedium => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 24 / 16,
  );

  /// Nunito w500, 14px, lineHeight 20/14, letterSpacing 0.1
  static TextStyle get titleSmall => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  /// Nunito w400, 16px, lineHeight 24/16, letterSpacing 0.5
  static TextStyle get bodyLarge => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 24 / 16,
  );

  /// Nunito w400, 14px, lineHeight 20/14, letterSpacing 0.25
  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 20 / 14,
  );

  /// Nunito w400, 12px, lineHeight 16/12, letterSpacing 0.4
  static TextStyle get bodySmall => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 16 / 12,
  );

  /// Nunito w500, 14px, lineHeight 20/14, letterSpacing 0.1
  static TextStyle get labelLarge => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  /// Nunito w500, 12px, lineHeight 16/12, letterSpacing 0.5
  static TextStyle get labelMedium => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 16 / 12,
  );

  /// Nunito w500, 11px, lineHeight 16/11, letterSpacing 0.5
  static TextStyle get labelSmall => GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 16 / 11,
  );

/// Button small: Nunito w500, 14px, lineHeight 20/14.
  static TextStyle get buttonSmall => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  /// Button medium: Nunito w500, 16px, lineHeight 24/16.
  static TextStyle get buttonMedium => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 24 / 16,
  );

  /// Button large: Nunito w500, 18px, lineHeight 24/18.
  static TextStyle get buttonLarge => GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 24 / 18,
  );
}

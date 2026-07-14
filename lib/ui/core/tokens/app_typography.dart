import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTypography {
  AppTypography._();

  /// Sora w700, 57px, lineHeight 64/57, letterSpacing -0.25
  static TextStyle get displayLarge => GoogleFonts.sora(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 64 / 57,
  );

  /// Sora w600, 45px, lineHeight 52/45, letterSpacing 0
  static TextStyle get displayMedium => GoogleFonts.sora(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 52 / 45,
  );

  /// Sora w600, 36px, lineHeight 44/36, letterSpacing 0
  static TextStyle get displaySmall => GoogleFonts.sora(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 44 / 36,
  );

  /// Sora w600, 32px, lineHeight 40/32, letterSpacing 0
  static TextStyle get headlineLarge => GoogleFonts.sora(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 40 / 32,
  );

  /// Sora w500, 28px, lineHeight 36/28, letterSpacing 0
  static TextStyle get headlineMedium => GoogleFonts.sora(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 36 / 28,
  );

  /// Sora w500, 24px, lineHeight 32/24, letterSpacing 0
  static TextStyle get headlineSmall => GoogleFonts.sora(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 32 / 24,
  );

  /// DM Sans w600, 22px, lineHeight 28/22, letterSpacing 0
  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 28 / 22,
  );

  /// DM Sans w600, 16px, lineHeight 24/16, letterSpacing 0.15
  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 24 / 16,
  );

  /// DM Sans w500, 14px, lineHeight 20/14, letterSpacing 0.1
  static TextStyle get titleSmall => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  /// DM Sans w400, 16px, lineHeight 24/16, letterSpacing 0.5
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 24 / 16,
  );

  /// DM Sans w400, 14px, lineHeight 20/14, letterSpacing 0.25
  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 20 / 14,
  );

  /// DM Sans w400, 12px, lineHeight 16/12, letterSpacing 0.4
  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 16 / 12,
  );

  /// DM Sans w500, 14px, lineHeight 20/14, letterSpacing 0.1
  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  /// DM Sans w500, 12px, lineHeight 16/12, letterSpacing 0.5
  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 16 / 12,
  );

  /// DM Sans w500, 11px, lineHeight 16/11, letterSpacing 0.5
  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 16 / 11,
  );

  /// Button small: DM Sans w600, 14px, lineHeight 20/14.
  static TextStyle get buttonSmall => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 20 / 14,
  );

  /// Button medium: DM Sans w600, 16px, lineHeight 24/16.
  static TextStyle get buttonMedium => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 24 / 16,
  );

  /// Button large: DM Sans w600, 18px, lineHeight 24/18.
  static TextStyle get buttonLarge => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 24 / 18,
  );
}
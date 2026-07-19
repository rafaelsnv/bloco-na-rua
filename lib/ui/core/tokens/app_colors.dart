// Design system color tokens for Bloco na Rua — Carnaval Sunset theme.
// Single source of truth for all color constants.

import "package:flutter/material.dart";

class AppColors {
  AppColors._();

  // Group 1 — Primary (Violet)
  static const Color primary = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF4C1D95);

  // Group 2 — Secondary (Rose)
  static const Color secondary = Color(0xFFFB7185);
  static const Color secondaryLight = Color(0xFFFDA4AF);
  static const Color secondaryDark = Color(0xFFE11D48);

  // Group 3 — Accent / CTA (Orange)
  static const Color accent = Color(0xFFF97316);
  static const Color accentLight = Color(0xFFFB923C);
  static const Color accentDark = Color(0xFFC2410C);

  // Group 4 — Tertiary (Teal)
  static const Color tertiary = Color(0xFF14B8A6);
  static const Color tertiaryDark = Color(0xFF0D9488);
  static const Color tertiaryContainerLight = Color(0xFFCCFBF1);
  static const Color tertiaryContainerDark = Color(0xFF134E4A);

  // Group 5 — Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainerLight = Color(0xFFFEE2E2);
  static const Color errorContainerDark = Color(0xFF991B1B);
  static const Color info = Color(0xFF0EA5E9);

  // Group 6 — Surface Light (Stone anchor + Violet tonal ladder)
  static const Color backgroundLight = Color(0xFFFAFAF9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF6F4FC);
  static const Color surfaceContainerLight = Color(0xFFECE7F7);
  static const Color surfaceContainerHighLight = Color(0xFFE3DAF4);
  static const Color surfaceContainerHighestLight = Color(0xFFD9CCEE);
  static const Color surfaceNeutralLight = Color(0xFFF0EFED);
  static const Color borderLight = Color(0xFFDCD2F0);

  // Group 7 — Surface Dark (Deep violet)
  static const Color backgroundDark = Color(0xFF0B0716);
  static const Color surfaceDark = Color(0xFF15101F);
  static const Color surfaceVariantDark = Color(0xFF1E1830);
  static const Color surfaceContainerDark = Color(0xFF2A2142);
  static const Color surfaceNeutralDark = Color(0xFF1A1626);
  static const Color borderDark = Color(0xFF3B2F5C);

  // Group 8 — Text Light
  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textTertiary = Color(0xFF78716C);
  static const Color textDisabled = Color(0xFFA8A29E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // Group 9 — Text Dark
  static const Color textPrimaryDark = Color(0xFFFAFAF9);
  static const Color textSecondaryDark = Color(0xFFD6D3D1);
  static const Color textTertiaryDark = Color(0xFFA8A29E);
  static const Color textDisabledDark = Color(0xFF57534E);
}

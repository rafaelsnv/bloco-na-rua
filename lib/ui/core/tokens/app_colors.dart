// Design system color tokens for Bloco na Rua — Fireworks on Velvet theme.
// Single source of truth for all color constants.

import "package:flutter/material.dart";

class AppColors {
  AppColors._();

  // Group 1 — Primary (Violet)
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF5B21B6);

  // Group 2 — Secondary (Magenta)
  static const Color secondary = Color(0xFFE11D74);
  static const Color secondaryLight = Color(0xFFFF3D81);
  static const Color secondaryDark = Color(0xFF831843);

  // Group 3 — Accent / CTA (Gold)
  static const Color accent = Color(0xFFD97706);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFF7C2D12);

  // Group 4 — Tertiary (Cyan)
  static const Color tertiary = Color(0xFF0E7490);
  static const Color tertiaryLight = Color(0xFF6DDBC8);
  static const Color tertiaryDark = Color(0xFF164E63);
  static const Color tertiaryContainerLight = Color(0xFFCFFAFE);
  static const Color tertiaryContainerDark = Color(0xFF164E63);

  // Group 5 — Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color errorDark = Color(0xFFF87171);
  static const Color errorContainerLight = Color(0xFFFEE2E2);
  static const Color errorContainerDark = Color(0xFF991B1B);
  static const Color info = Color(0xFF0EA5E9);
  static const Color warningContainerLight = Color(0xFF78350F);
  static const Color warningContainerDark = Color(0xFF451A03);
  static const Color infoContainerLight = Color(0xFF0C4A6E);
  static const Color infoContainerDark = Color(0xFF075985);
  static const Color successContainerLight = Color(0xFF14532D);
  static const Color successContainerDark = Color(0xFF052E16);

  // Group 6 — Surface Light (Stone anchor + Violet tonal ladder)
  static const Color backgroundLight = Color(0xFFFAFAF9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF6F4FC);
  static const Color surfaceContainerLight = Color(0xFFF5F3FF);
  static const Color surfaceContainerHighLight = Color(0xFFEDE9FE);
  static const Color surfaceContainerHighestLight = Color(0xFFDDD6FE);
  static const Color surfaceNeutralLight = Color(0xFFF0EFED);
  static const Color borderLight = Color(0xFFC4B5FD);

  // Group 7 — Surface Dark (Slate-based)
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color surfaceVariantDark = Color(0xFF2D3042);
  static const Color surfaceContainerDark = Color(0xFF374151);
  static const Color surfaceContainerHighDark = Color(0xFF3F4657);
  static const Color surfaceContainerHighestDark = Color(0xFF4B5563);
  static const Color borderDark = Color(0xFF475569);

  // Group 8 — Text Light
  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textTertiary = Color(0xFF78716C);
  static const Color textDisabled = Color(0xFFA8A29E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Group 9 — Text Dark
  static const Color textPrimaryDark = Color(0xFFFAFAF9);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF94A3B8);
  static const Color textDisabledDark = Color(0xFF64748B);
  static const Color textOnPrimaryDark = Color(0xFF2E1065);
}

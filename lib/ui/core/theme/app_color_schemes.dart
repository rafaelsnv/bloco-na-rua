import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";

/// Light mode ColorScheme using Indigo primary (#4F46E5) and Orange CTA (#F97316).
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary — Indigo #4F46E5
  primary: AppColors.primary,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE0E7FF),
  onPrimaryContainer: Color(0xFF1E1B4B),

  // Secondary — Primary Light #818CF8
  secondary: AppColors.primaryLight,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE0E7FF),
  onSecondaryContainer: Color(0xFF1E1B4B),

  // Tertiary — CTA Orange #F97316
  tertiary: AppColors.cta,
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFEDD5),
  onTertiaryContainer: Color(0xFF7C2D12),

  // Error — Semantic error red
  error: AppColors.error,
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFEE2E2),
  onErrorContainer: Color(0xFF991B1B),

  // Surface
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1E293B),
  surfaceContainerHighest: Color(0xFFE2E8F0),
  onSurfaceVariant: Color(0xFF64748B),

  // Outline
  outline: Color(0xFFE2E8F0),
  outlineVariant: Color(0xFFCBD5E1),

  // Utility
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),

  // Inverse — derived shade for light inversePrimary: #A5B4FC
  inverseSurface: Color(0xFF1E293B),
  onInverseSurface: Color(0xFFF1F5F9),
  inversePrimary: Color(0xFFA5B4FC),
);

/// Dark mode ColorScheme using Indigo Light primary (#818CF8) and lighter Orange CTA.
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary — Primary Light #818CF8
  primary: AppColors.primaryLight,
  onPrimary: Color(0xFF1E1B4B),
  primaryContainer: Color(0xFF3730A3),
  onPrimaryContainer: Color(0xFFE0E7FF),

  // Secondary — derived shade #A5B4FC
  secondary: Color(0xFFA5B4FC),
  onSecondary: Color(0xFF1E1B4B),
  secondaryContainer: Color(0xFF4338CA),
  onSecondaryContainer: Color(0xFFE0E7FF),

  // Tertiary — CTA Light #FB923C
  tertiary: Color(0xFFFB923C),
  onTertiary: Color(0xFF7C2D12),
  tertiaryContainer: Color(0xFFC2410C),
  onTertiaryContainer: Color(0xFFFFEDD5),

  // Error — derived shade #F87171
  error: Color(0xFFF87171),
  onError: Color(0xFF7F1D1D),
  errorContainer: Color(0xFF991B1B),
  onErrorContainer: Color(0xFFFEE2E2),

  // Surface
  surface: Color(0xFF1E293B),
  onSurface: Color(0xFFF1F5F9),
  surfaceContainerHighest: Color(0xFF334155),
  onSurfaceVariant: Color(0xFF94A3B8),

  // Outline
  outline: Color(0xFF475569),
  outlineVariant: Color(0xFF334155),

  // Utility
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),

  // Inverse — uses AppColors.primary #4F46E5 as inversePrimary
  inverseSurface: Color(0xFFF1F5F9),
  onInverseSurface: Color(0xFF1E293B),
  inversePrimary: AppColors.primary,
);

// Design system color tokens for Bloco na Rua.
// Single source of truth for all color constants.

import "package:flutter/material.dart";

class AppColors {
  AppColors._();

  // ============================================
  // Group 1 — Primary
  // ============================================
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);

  // ============================================
  // Group 2 — CTA / Accent
  // ============================================
  static const Color cta = Color(0xFFF97316);
  static const Color ctaLight = Color(0xFFFB923C);
  static const Color ctaDark = Color(0xFFEA580C);

  // ============================================
  // Group 3 — Semantic
  // ============================================
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ============================================
  // Group 4 — Surface Light
  // ============================================
  static const Color backgroundLight = Color(0xFFEEF2FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFE0E7FF);
  static const Color borderLight = Color(0xFFE2E8F0);

  // ============================================
  // Group 5 — Surface Dark
  // ============================================
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF334155);

  // ============================================
  // Group 6 — Text Light
  // ============================================
  static const Color textPrimaryLight = Color(0xFF1E1B4B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textDisabledLight = Color(0xFF94A3B8);

  // ============================================
  // Group 7 — Text Dark
  // ============================================
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textDisabledDark = Color(0xFF64748B);
}

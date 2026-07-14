// Design surface: lib/ui/core/tokens/app_radius.dart
// Single source of truth for all border-radius constants and pre-built BorderRadius instances.

import "package:flutter/material.dart";

/// Radii — design system border-radius tokens.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     color: AppColors.surfaceLight,
///     borderRadius: Radii.radiusMd,
///   ),
/// )
/// ```
class Radii {
  Radii._();

  /// No border radius — full-bleed elements.
  static const double none = 0.0;

  /// Extra small: 4px. Small badges, tags.
  static const double xs = 4.0;

  /// Small: 8px. Buttons, inputs, small cards.
  static const double sm = 8.0;

  /// Medium: 12px. Cards, sheets, modals.
  static const double md = 12.0;

  /// Large: 16px. Large cards, featured elements.
  static const double lg = 16.0;

  /// Extra large: 24px. Bottom sheets, major containers.
  static const double xl = 24.0;

  /// Full — circular/pill shape. Avatars, FABs.
  static const double full = 9999.0;

  /// BorderRadius.circular(xs) — 4px all corners.
  static final BorderRadius radiusXs = BorderRadius.circular(xs);

  /// BorderRadius.circular(sm) — 8px all corners.
  static final BorderRadius radiusSm = BorderRadius.circular(sm);

  /// BorderRadius.circular(md) — 12px all corners.
  static final BorderRadius radiusMd = BorderRadius.circular(md);

  /// BorderRadius.circular(lg) — 16px all corners.
  static final BorderRadius radiusLg = BorderRadius.circular(lg);

  /// BorderRadius.circular(xl) — 24px all corners.
  static final BorderRadius radiusXl = BorderRadius.circular(xl);

  /// BorderRadius.circular(full) — circular/pill all corners.
  static final BorderRadius radiusFull = BorderRadius.circular(full);

  /// Buttons: 8px all corners.
  static final BorderRadius button = radiusSm;

  /// Cards: 12px all corners.
  static final BorderRadius card = radiusMd;

  /// Inputs: 12px all corners (matches mockup's rounded-xl).
  static final BorderRadius input = radiusMd;

  /// FAB: 16px all corners.
  static final BorderRadius fab = radiusLg;

  /// Chips: 16px all corners (pill shape when height allows).
  static final BorderRadius chip = radiusLg;

  /// Avatars: circular/pill shape.
  static final BorderRadius avatar = radiusFull;

  /// Modals: 16px all corners.
  static final BorderRadius modal = radiusLg;

  /// Bottom sheet: 24px top-left and top-right only.
  static final BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}

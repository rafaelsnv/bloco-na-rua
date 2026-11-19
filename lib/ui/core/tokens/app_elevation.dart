// Design surface: lib/ui/core/tokens/app_elevation.dart
// Single source of truth for every elevation (and matching shadow) in the app.

import "package:flutter/material.dart";

/// Elevation — design system elevation tokens.
///
/// One canonical scale for the whole app: cards, FABs, snackbars and modals all
/// pick from this enum instead of hardcoded dp values.
///
/// Usage:
/// ```dart
/// Card(
///   elevation: AppElevation.sm.value,
///   child: child,
/// )
///
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: AppElevation.lg.shadow(Colors.black),
///   ),
/// )
/// ```
enum AppElevation {
  /// No shadow — flat surfaces.
  none(0),

  /// Extra small — 1dp. Cards at rest.
  sm(1),

  /// Medium — 3dp. Raised cards, dropdowns, snackbars.
  md(3),

  /// Large — 6dp. FABs, dialogs.
  lg(6),

  /// Extra large — 8dp. Navigation drawer, sticky CTAs.
  xl(8),

  /// Extra extra large — 12dp. Modal bottom sheets.
  xxl(12);

  const AppElevation(this.value);

  /// The elevation in logical pixels.
  final double value;

  /// Shadow opacity used in light mode.
  double get shadowOpacity => 0.10;

  /// Shadow opacity for [brightness] — shadows are deeper on dark surfaces.
  double shadowOpacityFor(Brightness brightness) =>
      brightness == Brightness.light ? shadowOpacity : 0.30;

  /// Shadow cast by this elevation, based on [color] as the shadow base.
  ///
  /// Pass [brightness] to match the ambient theme (dark surfaces need a
  /// stronger shadow to stay visible).
  List<BoxShadow> shadow(
    Color color, {
    Brightness brightness = Brightness.light,
  }) => [
    BoxShadow(
      offset: Offset(0, value / 2),
      blurRadius: value * 1.5,
      spreadRadius: 0,
      color: color.withValues(alpha: shadowOpacityFor(brightness)),
    ),
  ];

  /// Shadow for cards at rest.
  static List<BoxShadow> cardShadow(
    Color color, {
    Brightness brightness = Brightness.light,
  }) => md.shadow(color, brightness: brightness);

  /// Shadow for FABs and dialogs.
  static List<BoxShadow> fabShadow(
    Color color, {
    Brightness brightness = Brightness.light,
  }) => lg.shadow(color, brightness: brightness);

  /// Shadow for modal bottom sheets.
  static List<BoxShadow> modalShadow(
    Color color, {
    Brightness brightness = Brightness.light,
  }) => xxl.shadow(color, brightness: brightness);
}

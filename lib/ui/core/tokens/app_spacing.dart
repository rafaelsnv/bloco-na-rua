// ignore_for_file: constant_identifier_names

import "package:flutter/widgets.dart";

/// Spacing tokens for the Bloco na Rua design system.
///
/// All spacing values are based on a 4px grid system.
/// Use these constants instead of hardcoded values throughout the app.
///
/// Base unit: 4px
///
/// Example:
/// ```dart
/// Padding(padding: EdgeInsets.all(Spacing.space_md))
/// ```
class Spacing {
  Spacing._();

  // Base spacing tokens (4px grid)
  static const double space_0 = 0.0;
  static const double space_4xs = 2.0;
  static const double space_3xs = 4.0;
  static const double space_2xs = 8.0;
  static const double space_xs = 12.0;
  static const double space_sm = 16.0;
  static const double space_md = 24.0;
  static const double space_lg = 32.0;
  static const double space_xl = 48.0;
  static const double space_2xl = 64.0;
  static const double space_3xl = 80.0;
  static const double space_4xl = 96.0;

  // Semantic tokens for specific use cases
  static const double buttonPaddingVLg = 16.0;

  // Common layout combinations
  static const double pagePaddingMobile = 16.0;
  static const double pagePaddingTablet = 24.0;
  static const double pagePaddingDesktop = 32.0;
  static const double cardPadding = 16.0;
  static const double sectionGap = 24.0;
  static const double listItemVerticalPadding = 12.0;

  // Viewport breakpoints used to resolve the page padding.
  static const double tabletBreakpoint = 600.0;
  static const double desktopBreakpoint = 1000.0;

  /// Resolves the horizontal page padding for a viewport of [width] logical px.
  /// Mobile < 600, tablet < 1000, desktop >= 1000.
  static double pagePaddingForWidth(double width) {
    if (width < tabletBreakpoint) return pagePaddingMobile;
    if (width < desktopBreakpoint) return pagePaddingTablet;
    return pagePaddingDesktop;
  }

  /// Resolves the horizontal page padding for the current viewport width.
  static double pagePaddingFor(BuildContext context) =>
      pagePaddingForWidth(MediaQuery.sizeOf(context).width);
}

/// Icon size tokens (logical px) used across widgets.
///
/// Mirrors the ladder used by the icon button size metrics so icon sizes stay
/// consistent with the touch targets they live in.
class AppIconSizes {
  AppIconSizes._();

  /// 14px — inline glyphs next to small labels.
  static const double xs = 14.0;

  /// 16px — small button and list icons.
  static const double sm = 16.0;

  /// 20px — leading icons in rows and list tiles.
  static const double md = 20.0;

  /// 24px — default icon size.
  static const double lg = 24.0;

  /// 28px — section icons.
  static const double xl = 28.0;

  /// 32px — large feature icons.
  static const double xxl = 32.0;

  /// 40px — hero icons.
  static const double display = 40.0;

  /// 44px — hero icons.
  static const double displayLarge = 44.0;

  /// 48px — full-size feature icons.
  static const double displayXLarge = 48.0;
}

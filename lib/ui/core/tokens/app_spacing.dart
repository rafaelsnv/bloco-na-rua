// ignore_for_file: constant_identifier_names

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
}

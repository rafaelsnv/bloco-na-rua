import 'package:flutter/material.dart';

/// Elevation and shadow tokens following Material 3 design system.
class AppElevation {
  AppElevation._();

  /// Elevation level 0 - Flat surfaces
  static const double elevation0 = 0.0;

  /// Elevation level 1 - Cards at rest
  static const double elevation1 = 1.0;

  /// Elevation level 2 - Raised cards, dropdowns
  static const double elevation2 = 3.0;

  /// Elevation level 3 - FAB, dialogs, snackbars
  static const double elevation3 = 6.0;

  /// Elevation level 4 - Navigation drawer, sticky CTAs
  static const double elevation4 = 8.0;

  /// Elevation level 5 - Modal bottom sheets
  static const double elevation5 = 12.0;

  /// Generates a shadow configuration for the given elevation and brightness.
  static List<BoxShadow> shadowFor(double dp, Brightness brightness) {
    final alpha = brightness == Brightness.light ? 0.10 : 0.30;
    return [
      BoxShadow(
        offset: Offset(0, dp / 2),
        blurRadius: dp * 1.5,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, alpha),
      ),
    ];
  }

  /// Shadow for cards at rest (elevation2)
  static List<BoxShadow> cardShadow(Brightness brightness) =>
      shadowFor(elevation2, brightness);

  /// Shadow for FABs and dialogs (elevation3)
  static List<BoxShadow> fabShadow(Brightness brightness) =>
      shadowFor(elevation3, brightness);

  /// Shadow for modal bottom sheets (elevation5)
  static List<BoxShadow> modalShadow(Brightness brightness) =>
      shadowFor(elevation5, brightness);
}

import "package:flutter/animation.dart";

/// Holds animation duration constants for the design system.
///
/// Use these instead of hardcoded Duration values to maintain
/// consistent animation timing across the app.
class AppDurations {
  AppDurations._();

  /// No animation - instant state change (0ms).
  static const Duration instant = Duration.zero;

  /// Fast animation for hover states and micro-interactions (150ms).
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal animation for standard transitions (200ms).
  static const Duration normal = Duration(milliseconds: 200);

  /// Slow animation for page transitions and modals (300ms).
  static const Duration slow = Duration(milliseconds: 300);

  /// Slower animation for complex animations (400ms).
  static const Duration slower = Duration(milliseconds: 400);

  /// Long animation for loading indicators (1000ms).
  static const Duration long = Duration(milliseconds: 1000);

  /// Snackbar display duration (3000ms).
  static const Duration snackbar = Duration(milliseconds: 3000);
}

/// Holds animation curve constants for the design system.
///
/// Use these instead of hardcoded Curve values to maintain
/// consistent easing across the app.
class AppCurves {
  AppCurves._();

  /// Standard curve for most transitions.
  static const Curve standard = Curves.easeOutCubic;

  /// Curve for elements entering the screen.
  static const Curve entering = Curves.easeOutCubic;

  /// Curve for elements exiting the screen.
  static const Curve exiting = Curves.easeInCubic;

  /// Bouncy elastic curve for playful interactions.
  static const Curve bounce = Curves.elasticOut;
}

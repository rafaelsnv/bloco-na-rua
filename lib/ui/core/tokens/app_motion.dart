import 'package:flutter/material.dart';

class AppMotionDuration {
  AppMotionDuration._();

  static const Duration instant = Duration(milliseconds: 0);
  static const Duration short = Duration(milliseconds: 150);   // Press feedback
  static const Duration medium = Duration(milliseconds: 250);   // Default transitions
  static const Duration long = Duration(milliseconds: 350);     // Emphasis
  static const Duration slower = Duration(milliseconds: 500);    // Hero animations
}

class AppMotionEasing {
  AppMotionEasing._();

  static const Curve standard = Curves.easeOut;  // Material standard
  static const Curve emphasized = Curves.easeOut; // Brand interactions
  static const Curve decelerate = Curves.easeOut; // Entering elements
  static const Curve accelerate = Curves.easeIn;   // Exiting elements
}

class AppMotion {
  AppMotion._();

  static CurvedAnimation fabPress(AnimationController controller) => CurvedAnimation(
        parent: controller,
        curve: AppMotionEasing.emphasized,
      );

  static CurvedAnimation cardHover(AnimationController controller) => CurvedAnimation(
        parent: controller,
        curve: AppMotionEasing.standard,
      );

  static CurvedAnimation routePush(AnimationController controller) => CurvedAnimation(
        parent: controller,
        curve: AppMotionEasing.decelerate,
      );
}

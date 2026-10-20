import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_radius.dart";
import "../../tokens/app_duration.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";

/// Static helper class for showing themed SnackBars.
///
/// Does not hold any state — all methods are static.
/// Use the named constructors for each severity level:
/// ```dart
/// AppSnackbar.success(context, message: "Item saved!");
/// AppSnackbar.error(context, message: "Something went wrong.");
/// AppSnackbar.warning(context, message: "Check your input.");
/// AppSnackbar.info(context, message: "Here's a tip.");
/// ```
class AppSnackbar {
  AppSnackbar._();

  /// Shows a success-themed SnackBar with a success container background.
  static void success(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.successContainerLight,
      AppColors.successContainerDark,
      Icons.check_circle_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Shows an error-themed SnackBar with an error container background.
  static void error(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.errorContainerLight,
      AppColors.errorContainerDark,
      Icons.error_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Shows a warning-themed SnackBar with a warning container background.
  static void warning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.warningContainerLight,
      AppColors.warningContainerDark,
      Icons.warning_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Shows an info-themed SnackBar with an info container background.
  static void info(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.infoContainerLight,
      AppColors.infoContainerDark,
      Icons.info_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Internal helper that builds and shows the SnackBar.
  ///
  /// [containerLight]/[containerDark] select the container token per brightness
  /// (Material ColorScheme has no warning/info/successContainer slots). The
  /// content color is picked by container luminance so dark containers always
  /// get light text and light containers get dark text.
  static void _show(
    BuildContext context,
    Color containerLight,
    Color containerDark,
    IconData icon,
    String message,
    String? actionLabel,
    VoidCallback? onAction,
  ) {
    if (!context.mounted) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final container = isDark ? containerDark : containerLight;
    final contentColor = container.computeLuminance() > 0.5
        ? AppColors.textPrimary
        : AppColors.textPrimaryDark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: contentColor, size: 24),
            SizedBox(width: Spacing.space_sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: contentColor),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: contentColor,
                  padding: EdgeInsets.symmetric(horizontal: Spacing.space_sm),
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
        backgroundColor: container,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(Spacing.pagePaddingMobile),
        // Border radius 12px — same as Radii.radiusMd.
        shape: RoundedRectangleBorder(borderRadius: Radii.radiusMd),
        duration: AppDurations.snackbar,
        elevation: 4,
      ),
    );
  }
}

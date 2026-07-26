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

  /// Shows a success-themed SnackBar with a green background.
  static void success(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.success,
      Icons.check_circle_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Shows an error-themed SnackBar with a red background.
  static void error(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.error,
      Icons.error_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Shows a warning-themed SnackBar with an amber background.
  static void warning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.warning,
      Icons.warning_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Shows an info-themed SnackBar with a blue background.
  static void info(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      AppColors.info,
      Icons.info_rounded,
      message,
      actionLabel,
      onAction,
    );
  }

  /// Internal helper that builds and shows the SnackBar.
  static void _show(
    BuildContext context,
    Color color,
    IconData icon,
    String message,
    String? actionLabel,
    VoidCallback? onAction,
  ) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.textOnPrimary, size: 24),
            SizedBox(width: Spacing.space_sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textOnPrimary,
                  padding: EdgeInsets.symmetric(horizontal: Spacing.space_sm),
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
        backgroundColor: color,
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

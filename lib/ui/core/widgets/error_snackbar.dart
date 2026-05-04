import 'package:flutter/material.dart';

/// Factory class for consistent SnackBar notifications across the app.
///
/// Provides predefined error, success, and warning SnackBars with
/// consistent styling and behavior.
class ErrorSnackbar {
  ErrorSnackbar._();

  /// Shows a simple error SnackBar with red background.
  ///
  /// [context] - The build context.
  /// [message] - The error message to display.
  /// [duration] - How long the SnackBar should be visible (default: 4 seconds).
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red.shade600,
      duration: duration,
    );
  }

  /// Shows an error SnackBar with a retry action button.
  ///
  /// [context] - The build context.
  /// [message] - The error message to display.
  /// [onRetry] - Callback executed when retry is pressed.
  /// [duration] - How long the SnackBar should be visible (default: 6 seconds).
  static void showWithRetry(
    BuildContext context,
    String message,
    VoidCallback onRetry, {
    Duration duration = const Duration(seconds: 6),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red.shade600,
      duration: duration,
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.white,
        onPressed: onRetry,
      ),
    );
  }

  /// Shows a success SnackBar with green background.
  ///
  /// [context] - The build context.
  /// [message] - The success message to display.
  /// [duration] - How long the SnackBar should be visible (default: 3 seconds).
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green.shade600,
      duration: duration,
    );
  }

  /// Shows a warning SnackBar with orange background.
  ///
  /// [context] - The build context.
  /// [message] - The warning message to display.
  /// [duration] - How long the SnackBar should be visible (default: 4 seconds).
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      icon: Icons.warning,
      backgroundColor: Colors.orange.shade600,
      duration: duration,
    );
  }

  /// Internal helper to build and show a SnackBar with consistent styling.
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Duration duration,
    SnackBarAction? action,
  }) {
    // Check if context is still mounted to avoid showing SnackBar after navigation
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

/// Severity of a snackbar — the icon that carries it.
///
/// H6: the severity is no longer encoded by a tinted container (the old
/// per-severity fills encoded it by inverting lightness, which broke the
/// theme's `snackBarTheme`). One neutral surface is used for every
/// severity and the leading icon carries the meaning.
enum _SnackSeverity {
  success(Icons.check_circle_rounded, AppColors.success),
  error(Icons.error_rounded, AppColors.error),
  warning(Icons.warning_rounded, AppColors.warningInk),
  info(Icons.info_rounded, AppColors.infoInk);

  const _SnackSeverity(this.icon, this.ink);

  /// The leading glyph that identifies the severity.
  final IconData icon;

  /// The ink of [icon] — always clears 3:1 on the neutral inverse surface.
  final Color ink;
}

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

  /// Shows a success SnackBar — the severity is carried by the check icon.
  static void success(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
  }) {
    _show(
      context,
      _SnackSeverity.success,
      message,
      actionLabel,
      onAction,
      showCloseIcon,
    );
  }

  /// Shows an error SnackBar — the severity is carried by the error icon.
  static void error(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
  }) {
    _show(
      context,
      _SnackSeverity.error,
      message,
      actionLabel,
      onAction,
      showCloseIcon,
    );
  }

  /// Shows a warning SnackBar — the severity is carried by the warning icon.
  static void warning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
  }) {
    _show(
      context,
      _SnackSeverity.warning,
      message,
      actionLabel,
      onAction,
      showCloseIcon,
    );
  }

  /// Shows an info SnackBar — the severity is carried by the info icon.
  static void info(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
  }) {
    _show(
      context,
      _SnackSeverity.info,
      message,
      actionLabel,
      onAction,
      showCloseIcon,
    );
  }

  /// Internal helper that builds and shows the SnackBar.
  ///
  /// H6: one neutral surface for every severity — `colorScheme.inverseSurface`
  /// with `colorScheme.onInverseSurface` as the content ink, which is what the
  /// theme's `snackBarTheme` already declares. The severity lives in the
  /// leading icon, so no per-severity container colour is hardcoded here.
  static void _show(
    BuildContext context,
    _SnackSeverity severity,
    String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon,
  ) {
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(severity.icon, color: severity.ink, size: AppIconSizes.lg),
            SizedBox(width: Spacing.space_sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onInverseSurface,
                ),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.inversePrimary,
                  padding: EdgeInsets.symmetric(horizontal: Spacing.space_sm),
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
        backgroundColor: colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        // L5: the bottom clearance keeps the toast above the FAB instead of
        // sliding under it.
        margin: const EdgeInsets.only(
          left: Spacing.pagePaddingMobile,
          right: Spacing.pagePaddingMobile,
          bottom: Spacing.snackbarFabClearance,
        ),
        // Opt-in close affordance for long messages that the user wants to
        // dismiss before the timeout. Off by default so the short snackbars
        // keep their current look.
        showCloseIcon: showCloseIcon,
        closeIconColor: colorScheme.onInverseSurface,
        // Border radius 12px — same as Radii.radiusMd.
        shape: RoundedRectangleBorder(borderRadius: Radii.radiusMd),
        duration: AppDurations.snackbar,
        // Floating snackbars sit just above the content they report on:
        // AppElevation.md (3) is the canonical raised-surface step.
        elevation: AppElevation.md.value,
      ),
    );
  }
}

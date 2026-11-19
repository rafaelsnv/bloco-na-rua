import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:flutter/material.dart";

/// Static helper class for themed confirm and alert dialogs.
///
/// Does NOT extend StatelessWidget — this is a pure utility class.
class AppDialog {
  AppDialog._();

  /// Shows a two-button confirm dialog.
  ///
  /// Returns `true` if the user taps confirm,
  /// `false` if the user taps cancel,
  /// or `null` if the dialog is dismissed (back button or tap outside).
  ///
  /// [confirmLabel] and [cancelLabel] are required — the dialog owns no
  /// wording, the caller does (L8).
  ///
  /// [isDestructive] paints the confirm button in the error variant.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<bool>(
      context: context,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.54),
      builder: (_) => _ConfirmDialogContent(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }

  /// Shows a single-button alert dialog.
  ///
  /// Returns `void` after the user dismisses the dialog.
  ///
  /// [okLabel] defaults to "OK", which reads the same in pt-BR and en.
  ///
  /// [icon] is optional; when provided it appears above the title.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String okLabel = "OK",
    IconData? icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.54),
      builder: (_) => _AlertDialogContent(
        title: title,
        message: message,
        okLabel: okLabel,
        icon: icon,
      ),
    ).then((_) {});
  }
}

class _ConfirmDialogContent extends StatelessWidget {
  const _ConfirmDialogContent({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDestructive,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      // Shape, elevation and surface come from the theme's dialogTheme;
      // only the ink of the text is pinned here, straight from the scheme.
      backgroundColor: colorScheme.surface,
      title: Text(title, style: TextStyle(color: colorScheme.onSurface)),
      content: Text(
        message,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      actions: [
        // No colour override: the cancel button inherits the theme's
        // textButtonTheme (brand ink), like every other text button.
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        // The destructive variant lives in the shared button, so its fill and
        // its ink stay a matched pair (the scheme's dark-mode error red is
        // too light for the button's white ink).
        AppButton(
          label: confirmLabel,
          variant: isDestructive
              ? AppButtonVariant.error
              : AppButtonVariant.accent,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class _AlertDialogContent extends StatelessWidget {
  const _AlertDialogContent({
    required this.title,
    required this.message,
    required this.okLabel,
    this.icon,
  });

  final String title;
  final String message;
  final String okLabel;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      icon: icon != null
          ? Icon(
              icon,
              size: AppIconSizes.displayXLarge,
              color: colorScheme.primary,
            )
          : null,
      title: Text(title, style: TextStyle(color: colorScheme.onSurface)),
      content: Text(
        message,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      actions: [
        AppButton(
          label: okLabel,
          variant: AppButtonVariant.accent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

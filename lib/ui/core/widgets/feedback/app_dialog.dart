// lib/ui/core/widgets/feedback/app_dialog.dart
//
// Static helper dialogs for consistent confirm/alert patterns.
//
// Usage:
//
//   // Confirm dialog — returns true/false/null
//   final result = await AppDialog.confirm(
//     context,
//     title: "Excluir item?",
//     message: "Esta acao nao pode ser desfeita.",
//     confirmLabel: "Excluir",
//     isDestructive: true,
//   );
//
//   // Alert dialog — returns void
//   await AppDialog.alert(
//     context,
//     title: "Aviso",
//     message: "Sessão expirada. Faça login novamente.",
//   );

import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_radius.dart";

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
  /// [isDestructive] applies [AppColors.error] to the confirm button.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = "Confirmar",
    String cancelLabel = "Cancelar",
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
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
  /// [icon] is optional; when provided it appears above the title.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String okLabel = "OK",
    IconData? icon,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => _AlertDialogContent(
        title: title,
        message: message,
        okLabel: okLabel,
        icon: icon,
      ),
    ).then((_) {});
  }
}

// -------------------------------------------------------------------------
// _ConfirmDialogContent
// -------------------------------------------------------------------------

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
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(borderRadius: Radii.modal),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: isDestructive
                ? AppColors.error
                : AppColors.primary,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------------------
// _AlertDialogContent
// -------------------------------------------------------------------------

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
    return AlertDialog(
      icon: icon != null
          ? Icon(icon, size: 48, color: AppColors.primary)
          : null,
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(borderRadius: Radii.modal),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(okLabel),
        ),
      ],
    );
  }
}

import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_state_view.dart";
import "package:flutter/material.dart";

/// Full-screen centered error state widget.
///
/// Displays an error icon, a title, an optional message, and an optional
/// retry button. Intended for use as a full-screen error placeholder
/// in async state failures.
///
/// Thin wrapper over [AppStateView].
///
/// Example:
/// ```dart
/// when(
///   (state) => state.status == Status.failure,
///   builder: (context, state) => AppError(
///     message: state.failure.message,
///     onRetry: () => context.read<MyCubit>().retry(),
///   ),
/// )
/// ```
class AppError extends StatelessWidget {
  /// Creates an [AppError] widget.
  ///
  /// [title] defaults to "Algo deu errado" (full-screen mode only; in
  /// [compact] mode no title is rendered unless one is passed).
  /// [message] is optional and displayed below the title when provided.
  /// [icon] defaults to [Icons.error_outline_rounded].
  /// [onRetry] is optional; when provided, a retry button is shown.
  /// [retryLabel] defaults to "Tentar novamente".
  const AppError({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.onRetry,
    this.retryLabel,
    this.compact = false,
  });

  /// Optional custom title. Defaults to "Algo deu errado".
  final String? title;

  /// Optional detailed error message displayed below the title.
  final String? message;

  /// Error icon. Defaults to [Icons.error_outline_rounded].
  final IconData? icon;

  /// Optional retry callback. When provided, a retry button is rendered.
  final VoidCallback? onRetry;

  /// Label for the retry button. Defaults to "Tentar novamente".
  final String? retryLabel;

  /// When true the error renders as an inline block (smaller icon, secondary
  /// retry button, no default title) instead of a full-screen placeholder.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppStateView(
      icon: icon ?? Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      iconSize: compact ? AppIconSizes.xxl : 64,
      title: compact ? title : (title ?? l10n.coreErrorTitle),
      message: message,
      action: onRetry != null
          ? AppButton(
              label: retryLabel ?? l10n.coreRetry,
              icon: const Icon(Icons.refresh_rounded),
              variant: compact
                  ? AppButtonVariant.secondary
                  : AppButtonVariant.primary,
              size: compact ? AppButtonSizeMetrics.sm : AppButtonSizeMetrics.md,
              onPressed: onRetry,
            )
          : null,
      compact: compact,
    );
  }
}

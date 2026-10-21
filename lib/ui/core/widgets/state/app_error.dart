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
  /// [title] defaults to "Algo deu errado".
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

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      icon: icon ?? Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      iconSize: 64,
      title: title ?? "Algo deu errado",
      message: message,
      action: onRetry != null
          ? AppButton(
              label: retryLabel ?? "Tentar novamente",
              icon: const Icon(Icons.refresh_rounded),
              onPressed: onRetry,
            )
          : null,
    );
  }
}

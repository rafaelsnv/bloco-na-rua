import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";
import "../buttons/app_button.dart";

/// Full-screen centered error state widget.
///
/// Displays an error icon, a title, an optional message, and an optional
/// retry button. Intended for use as a full-screen error placeholder
/// in async state failures.
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),

            // Gap: icon -> title
            const SizedBox(height: Spacing.space_md),

            // Title
            Text(
              title ?? "Algo deu errado",
              style: AppTypography.headlineSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Gap: title -> message
            if (message != null) ...[
              const SizedBox(height: Spacing.space_xs),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Gap: message -> retry button
            if (onRetry != null) ...[
              const SizedBox(height: Spacing.space_lg),
              AppButton(
                label: retryLabel ?? "Tentar novamente",
                icon: const Icon(Icons.refresh_rounded),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

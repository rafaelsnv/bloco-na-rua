import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";
import "../buttons/app_button.dart";

/// Full-screen centered empty state widget.
///
/// Displays an icon, a title, an optional message, and an optional CTA button.
/// Intended for use as a full-screen placeholder when a list or content area
/// is empty.
///
/// Example:
/// ```dart
/// when(
///   (state) => state.items.isEmpty,
///   builder: (context, state) => AppEmpty(
///     message: "Nenhum bloco cadastrado ainda.",
///     actionLabel: "Criar bloco",
///     onAction: () => context.push(Routes.createBlock),
///   ),
/// )
/// ```
class AppEmpty extends StatelessWidget {
  /// Creates an [AppEmpty] widget.
  ///
  /// [title] is optional and defaults to "Nada por aqui".
  /// [message] is optional and displayed below the title when provided.
  /// [icon] defaults to [Icons.inbox_outlined].
  /// [actionLabel] is optional; when provided alongside [onAction], a CTA
  ///   button is rendered.
  /// [onAction] is optional; when provided alongside [actionLabel], a CTA
  ///   button is rendered. Both must be non-null for the button to appear.
  const AppEmpty({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  /// Optional custom title. Defaults to "Nada por aqui".
  final String? title;

  /// Optional detailed message displayed below the title.
  final String? message;

  /// Icon displayed above the title. Defaults to [Icons.inbox_outlined].
  final IconData? icon;

  /// Optional CTA button label. When provided alongside [onAction], a CTA
  /// button is rendered.
  final String? actionLabel;

  /// Optional CTA button press handler. When provided alongside [actionLabel],
  /// a CTA button is rendered.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final showCtaButton = actionLabel != null && onAction != null;

    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon (only shown when provided)
            if (icon != null) ...[
              Icon(
                icon,
                size: 96,
                color: AppColors.primaryLight,
              ),
              // Gap: icon -> title
              const SizedBox(height: Spacing.space_md),
            ],

            // Title (only shown when provided)
            if (title != null)
              Text(
                title!,
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

            // Gap: message -> CTA button
            if (showCtaButton) ...[
              const SizedBox(height: Spacing.space_lg),
              AppButton(
                label: actionLabel!,
                icon: const Icon(Icons.add_rounded),
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

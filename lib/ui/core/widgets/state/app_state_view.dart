import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

/// Shared skeleton for full-screen state placeholders (empty, error, ...).
///
/// Renders the same vertical rhythm everywhere: icon, gap, title, gap,
/// message, gap, optional action. A null [icon]/[title]/[message] hides that
/// block (and its gap).
///
/// Example:
/// ```dart
/// AppStateView(
///   icon: Icons.cloud_off_rounded,
///   iconColor: colorScheme.error,
///   title: "Algo deu errado",
///   message: "Não foi possível carregar os dados.",
///   action: AppButton(label: "Tentar novamente", onPressed: onRetry),
/// )
/// ```
class AppStateView extends StatelessWidget {
  /// Creates an [AppStateView].
  const AppStateView({
    super.key,
    required this.iconColor,
    this.icon,
    this.iconSize = 64,
    this.title,
    this.message,
    this.action,
  });

  /// Icon displayed above the title. When null, no icon block is rendered.
  final IconData? icon;

  /// Color of the icon.
  final Color iconColor;

  /// Size of the icon, in logical pixels.
  final double iconSize;

  /// Optional headline. When null, no title block is rendered.
  final String? title;

  /// Optional supporting text below the title.
  final String? message;

  /// Optional action widget (usually a button) below the message.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize, color: iconColor),
              // Gap: icon -> title
              const SizedBox(height: Spacing.space_md),
            ],
            if (title != null)
              Text(
                title!,
                style: AppTypography.headlineSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            // Gap: title -> message
            if (message != null) ...[
              const SizedBox(height: Spacing.space_xs),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // Gap: message -> action
            if (action != null) ...[
              const SizedBox(height: Spacing.space_lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

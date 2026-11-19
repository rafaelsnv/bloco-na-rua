import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

/// Shared skeleton for state placeholders (empty, error, ...).
///
/// Renders the same vertical rhythm everywhere: icon, gap, title, gap,
/// message, gap, optional action. A null [icon]/[title]/[message] hides that
/// block (and its gap).
///
/// [compact] renders the same content as an inline block (tight gaps, no
/// page padding, no vertical centering) so it can live inside a card or a
/// section instead of taking over the whole screen.
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
    this.compact = false,
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

  /// When true the state renders as an inline block instead of a full-screen
  /// placeholder.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final children = <Widget>[
      if (icon != null) ...[
        Icon(icon, size: iconSize, color: iconColor),
        // Gap: icon -> title (or icon -> message when there is no title)
        SizedBox(
          height: compact
              ? (title == null ? Spacing.space_sm : Spacing.space_xs)
              : Spacing.space_md,
        ),
      ],
      if (title != null)
        Text(
          title!,
          style:
              (compact
                      ? AppTypography.titleMedium
                      : AppTypography.headlineSmall)
                  .copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
      if (message != null) ...[
        // Gap: title -> message
        if (!compact || title != null)
          SizedBox(height: compact ? Spacing.space_4xs : Spacing.space_xs),
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
        SizedBox(height: compact ? Spacing.space_sm : Spacing.space_lg),
        action!,
      ],
    ];

    if (compact) {
      return Padding(
        padding: const EdgeInsets.all(Spacing.space_sm),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

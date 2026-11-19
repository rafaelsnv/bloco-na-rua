import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_state_view.dart";
import "package:flutter/material.dart";

/// Full-screen centered empty state widget.
///
/// Displays an icon, a title, an optional message, and an optional CTA button.
/// Intended for use as a full-screen placeholder when a list or content area
/// is empty. Thin wrapper over [AppStateView].
///
/// [compact] renders the same content as an inline block (small icon, no
/// vertical centering, tight padding) so it can live inside a section — a
/// card or a page column — instead of taking over the whole screen.
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
  /// [title], [message] and [icon] are optional; each is rendered only when
  /// provided. [actionLabel]/[onAction] render a primary CTA and
  /// [secondaryActionLabel]/[onSecondaryAction] an outlined secondary one —
  /// both pairs must be non-null for the button to appear.
  const AppEmpty({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.compact = false,
  });

  /// Optional custom title.
  final String? title;

  /// Optional detailed message displayed below the title.
  final String? message;

  /// Optional icon displayed above the title.
  final IconData? icon;

  /// Optional CTA button label.
  final String? actionLabel;

  /// Optional CTA button press handler.
  final VoidCallback? onAction;

  /// Optional secondary CTA button label.
  final String? secondaryActionLabel;

  /// Optional secondary CTA button press handler.
  final VoidCallback? onSecondaryAction;

  /// When true the empty state renders as an inline block (small icon, no
  /// vertical centering, tight padding) instead of a full-screen placeholder.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final showCta = actionLabel != null && onAction != null;
    final showSecondary =
        secondaryActionLabel != null && onSecondaryAction != null;

    return AppStateView(
      icon: icon,
      iconColor: Theme.of(context).colorScheme.primary,
      // The compact variant keeps the icon small so it does not dominate the
      // section it is embedded in; the full-screen one keeps its hero icon.
      iconSize: compact ? AppIconSizes.xxl : 96,
      title: title,
      message: message,
      action: _buildActions(showCta: showCta, showSecondary: showSecondary),
      compact: compact,
    );
  }

  /// The CTA area below the message.
  ///
  /// A single CTA keeps the full-width look of the full-screen state; two
  /// CTAs sit side by side in a [Wrap] so they drop to the next line instead
  /// of overflowing the row on a narrow screen or at a large text scale.
  Widget? _buildActions({required bool showCta, required bool showSecondary}) {
    if (!showCta && !showSecondary) return null;

    final actions = <Widget>[
      if (showCta) AppButton(label: actionLabel!, onPressed: onAction),
      if (showSecondary)
        AppButton(label: secondaryActionLabel!, onPressed: onSecondaryAction),
    ];

    if (actions.length == 1) {
      return Row(children: [Expanded(child: actions.first)]);
    }

    return Wrap(
      spacing: Spacing.space_sm,
      runSpacing: Spacing.space_xs,
      alignment: WrapAlignment.center,
      children: actions,
    );
  }
}

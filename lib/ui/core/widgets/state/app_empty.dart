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

  @override
  Widget build(BuildContext context) {
    final showCta = actionLabel != null && onAction != null;
    final showSecondary =
        secondaryActionLabel != null && onSecondaryAction != null;

    return AppStateView(
      icon: icon,
      iconColor: Theme.of(context).colorScheme.primary,
      iconSize: 96,
      title: title,
      message: message,
      action: (showCta || showSecondary)
          ? Row(
              children: [
                if (showCta)
                  Expanded(
                    child: AppButton(label: actionLabel!, onPressed: onAction),
                  ),
                if (showCta && showSecondary)
                  const SizedBox(width: Spacing.space_sm),
                if (showSecondary)
                  Expanded(
                    child: AppButton(
                      label: secondaryActionLabel!,
                      onPressed: onSecondaryAction,
                    ),
                  ),
              ],
            )
          : null,
    );
  }
}

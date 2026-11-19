import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:flutter/material.dart";

/// A design-system-compliant icon button widget supporting three size presets,
/// tooltip, hover/press/disabled states.
///
/// The [tooltip] is required: it doubles as the accessible label, so an
/// icon-only control is never unannounced to screen readers.
class AppIconButton extends StatelessWidget {
  /// Creates an AppIconButton.
  ///
  /// All parameters follow the design system token conventions.
  ///
  /// [tooltip] is required and is used as the accessibility label.
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    this.size = AppIconButtonSizeMetrics.md,
    this.color,
    this.onPressed,
    super.key,
  });

  /// The icon data to display.
  final IconData icon;

  /// Size preset pulling all metrics from [AppIconButtonSizeMetrics].
  final AppIconButtonSizeMetrics size;

  /// Optional color override for the icon. Defaults to the primary color.
  final Color? color;

  /// Callback fired when the button is tapped. Set to null when
  /// the button is disabled.
  final VoidCallback? onPressed;

  /// The accessible label of the button — also shown as the hover/long-press
  /// tooltip. Required: an icon-only control must always announce itself.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = onPressed;
    final isDisabled = effectiveOnPressed == null;
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveKey = key ?? Key('app_icon_button_$tooltip');

    // The tooltip gives the hover/long-press hint; the explicit Semantics
    // label is what screen readers announce — an icon-only control must
    // always say what it does. The tooltip is excluded from semantics so the
    // label is not announced twice.
    return Semantics(
      label: tooltip,
      button: true,
      child: Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: IconButton(
            key: effectiveKey,
            icon: Icon(
              icon,
              size: size.iconSize,
              color: color ?? _iconColor(context),
            ),
            onPressed: effectiveOnPressed,
            visualDensity: size.visualDensity,
            // Every size enforces the 48dp touch target (C2/a11y) — never pass
            // an empty BoxConstraints, which would drop IconButton's 48dp minimum.
            constraints: BoxConstraints(
              minWidth: size.minTouchTarget,
              minHeight: size.minTouchTarget,
            ),
            splashRadius: animationsDisabled ? 0 : null,
            hoverColor: animationsDisabled
                ? Colors.transparent
                : AppColors.tint(colorScheme.primary, 0.10),
          ),
        ),
      ),
    );
  }

  Color _iconColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
}

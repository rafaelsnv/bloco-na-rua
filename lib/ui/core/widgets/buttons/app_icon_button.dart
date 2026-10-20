import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:flutter/material.dart";

/// A design-system-compliant icon button widget supporting three size presets,
/// tooltip, hover/press/disabled states.
class AppIconButton extends StatelessWidget {
  /// Creates an AppIconButton.
  ///
  /// All parameters follow the design system token conventions.
  const AppIconButton({
    required this.icon,
    this.size = AppIconButtonSizeMetrics.md,
    this.color,
    this.onPressed,
    this.tooltip,
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

  /// Optional tooltip text for accessibility.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = onPressed;
    final isDisabled = effectiveOnPressed == null;
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveKey = key ?? Key('app_icon_button_$tooltip');

    final Widget button = Opacity(
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
        constraints: size.minTouchTarget > 0
            ? BoxConstraints(
                minWidth: size.minTouchTarget,
                minHeight: size.minTouchTarget,
              )
            : const BoxConstraints(),
        splashRadius: animationsDisabled ? 0 : null,
        hoverColor: animationsDisabled
            ? Colors.transparent
            : colorScheme.primary.withValues(alpha: 0.1),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }

  Color _iconColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
}

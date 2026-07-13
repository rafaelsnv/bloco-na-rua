import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";

/// Icon button size taxonomy with associated sizing tokens.
enum AppIconButtonSize {
  /// Small: 36px touch target.
  sm,

  /// Medium: 44px touch target, minimum 48px for accessibility.
  md,

  /// Large: 52px touch target, minimum 48px for accessibility.
  lg,
}

/// A design-system-compliant icon button widget supporting three size presets,
/// tooltip, hover/press/disabled states.
class AppIconButton extends StatelessWidget {
  /// Creates an AppIconButton.
  ///
  /// All parameters follow the design system token conventions.
  const AppIconButton({
    required this.icon,
    this.size = AppIconButtonSize.md,
    this.color,
    this.onPressed,
    this.tooltip,
    super.key,
  });

  /// The icon data to display.
  final IconData icon;

  /// Size preset controlling touch target dimensions.
  final AppIconButtonSize size;

  /// Optional color override for the icon. Defaults to the primary color.
  final Color? color;

  /// Callback fired when the button is tapped. Set to null when
  /// the button is disabled.
  final VoidCallback? onPressed;

  /// Optional tooltip text for accessibility.
  final String? tooltip;

  // -------------------------------------------------------------------------
  // Size tokens
  // -------------------------------------------------------------------------

  static const Map<AppIconButtonSize, double> _iconSizeTokens = {
    AppIconButtonSize.sm: 20.0,
    AppIconButtonSize.md: 24.0,
    AppIconButtonSize.lg: 28.0,
  };

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final iconSize = _iconSizeTokens[size]!;
    final effectiveOnPressed = onPressed;
    final isDisabled = effectiveOnPressed == null;
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);

    // Determine visual density based on size.
    // IconButton default touch target is 48px; we use compact to reduce
    // visual size while maintaining touch target via constraints.
    final VisualDensity visualDensity;
    switch (size) {
      case AppIconButtonSize.sm:
        // Compact reduces the visual padding to achieve ~36px visual size.
        visualDensity = const VisualDensity(horizontal: -4, vertical: -4);
      case AppIconButtonSize.md:
        // Slightly compact for 44px visual with 48px touch target.
        visualDensity = const VisualDensity(horizontal: -2, vertical: -2);
      case AppIconButtonSize.lg:
        // Standard visual density; 52px visual with 48px+ touch target.
        visualDensity = VisualDensity.standard;
    }

    // Minimum 48dp touch target for md and lg (accessibility).
    // sm uses its natural 36px touch target.
    final BoxConstraints constraints;
    if (size == AppIconButtonSize.sm) {
      constraints = const BoxConstraints();
    } else {
      constraints = const BoxConstraints(minWidth: 48, minHeight: 48);
    }

    final Widget button = Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: IconButton(
        icon: Icon(icon, size: iconSize, color: color ?? _iconColor(context)),
        onPressed: effectiveOnPressed,
        visualDensity: visualDensity,
        constraints: constraints,
        // Disable splash/ink effect when animations are disabled.
        splashRadius: animationsDisabled ? 0 : null,
        hoverColor: animationsDisabled
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: 0.1),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }

    return button;
  }

  Color _iconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.primaryLight : AppColors.primary;
  }
}

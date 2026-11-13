import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";

/// A design-system-compliant card widget supporting elevation presets,
/// optional tap interaction, and consistent padding and radius tokens.
class AppCard extends StatelessWidget {
  /// Creates an AppCard.
  ///
  /// All parameters follow the design system token conventions.
  const AppCard({
    required this.child,
    this.onTap,
    this.elevation = AppElevation.sm,
    this.padding,
    this.radius,
    this.color,
    super.key,
  });

  /// The primary content displayed inside the card.
  final Widget child;

  /// Optional tap callback. When provided the card becomes interactive
  /// and wraps child in an InkWell for Material ripple feedback.
  final VoidCallback? onTap;

  /// Elevation preset controlling the card shadow depth.
  /// Defaults to [AppElevation.sm].
  final AppElevation elevation;

  /// Internal padding around [child].
  /// Defaults to [EdgeInsets.all(Spacing.cardPadding)].
  final EdgeInsetsGeometry? padding;

  /// Overrides the default [Radii.card] border radius.
  final BorderRadius? radius;

  /// Overrides the default surface color from the current theme.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final computedPadding = padding ?? EdgeInsets.all(Spacing.cardPadding);
    final computedRadius = radius ?? Radii.card;
    final defaultColor = Theme.of(context).colorScheme.surface;

    // The Card is the Material surface, so the InkWell paints its ripple on
    // it directly — no extra Material wrapper (that would stack shadows).
    final content = Padding(padding: computedPadding, child: child);

    return Card(
      elevation: elevation.value,
      shape: RoundedRectangleBorder(
        borderRadius: computedRadius,
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: Radii.outlineWidth,
        ),
      ),
      color: color ?? defaultColor,
      margin: EdgeInsets.zero,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, borderRadius: computedRadius, child: content),
    );
  }
}

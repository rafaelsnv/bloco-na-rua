import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";

/// Card elevation taxonomy.
///
/// Elevation values map to logical Material elevation steps:
///   none=0, xs=1, sm=2, md=4, lg=8
enum AppCardElevation {
  /// No shadow — flat card.
  none,

  /// Extra small shadow — 1dp.
  xs,

  /// Small shadow — 2dp. Default for interactive cards.
  sm,

  /// Medium shadow — 4dp.
  md,

  /// Large shadow — 8dp.
  lg,
}

/// A design-system-compliant card widget supporting elevation presets,
/// optional tap interaction, and consistent padding and radius tokens.
class AppCard extends StatelessWidget {
  /// Creates an AppCard.
  ///
  /// All parameters follow the design system token conventions.
  const AppCard({
    required this.child,
    this.onTap,
    this.elevation = AppCardElevation.none,
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
  /// Defaults to [AppCardElevation.sm].
  final AppCardElevation elevation;

  /// Internal padding around [child].
  /// Defaults to [EdgeInsets.all(Spacing.cardPadding)].
  final EdgeInsetsGeometry? padding;

  /// Overrides the default [Radii.card] border radius.
  final BorderRadius? radius;

  /// Overrides the default surface color from the current theme.
  final Color? color;

  /// Card outline width — 1.5px for clear visual boundary.
  static const double outlineWidth = 1.5;

  static const Map<AppCardElevation, double> _elevationTokens = {
    AppCardElevation.none: 0.0,
    AppCardElevation.xs: 1.0,
    AppCardElevation.sm: 2.0,
    AppCardElevation.md: 4.0,
    AppCardElevation.lg: 8.0,
  };

  @override
  Widget build(BuildContext context) {
    final computedPadding = padding ?? EdgeInsets.all(Spacing.cardPadding);
    final computedRadius = radius ?? Radii.card;
    final computedElevation = _elevationTokens[elevation]!;
    final defaultColor = Theme.of(context).colorScheme.surface;

    final card = Card(
      elevation: computedElevation,
      shape: RoundedRectangleBorder(
        borderRadius: computedRadius,
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: outlineWidth,
        ),
      ),
      color: color ?? defaultColor,
      margin: EdgeInsets.zero,
      child: Padding(padding: computedPadding, child: child),
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      elevation: computedElevation,
      borderRadius: computedRadius,
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: computedRadius, child: card),
    );
  }
}

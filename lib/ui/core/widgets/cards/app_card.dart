// lib/ui/core/widgets/cards/app_card.dart
//
// Bloco na Rua design system card component.
//
// Stateful behaviour:
//   - Hover (when onTap is provided): translateY(-2px) via AnimatedContainer.
//   - Press (when onTap is provided): scale 0.98 via AnimatedScale.
//   - Animations are disabled when MediaQuery.disableAnimationsOf(context) is true.

import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";

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
    this.elevation = AppCardElevation.sm,
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

  /// Overrides the default surface colour from the current theme.
  final Color? color;

  // -------------------------------------------------------------------------
  // Elevation mapping
  // -------------------------------------------------------------------------

  static const Map<AppCardElevation, double> _elevationTokens = {
    AppCardElevation.none: 0.0,
    AppCardElevation.xs: 1.0,
    AppCardElevation.sm: 2.0,
    AppCardElevation.md: 4.0,
    AppCardElevation.lg: 8.0,
  };

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final computedPadding = padding ?? EdgeInsets.all(Spacing.cardPadding);
    final computedRadius = radius ?? Radii.card;
    final computedElevation = _elevationTokens[elevation]!;
    final defaultColor = Theme.of(context).colorScheme.surface;

    final card = Card(
      elevation: computedElevation,
      shape: RoundedRectangleBorder(borderRadius: computedRadius),
      color: color ?? defaultColor,
      margin: EdgeInsets.zero,
      child: Padding(padding: computedPadding, child: child),
    );

    if (onTap == null) {
      return card;
    }

    final animationsDisabled = MediaQuery.disableAnimationsOf(context);

    if (animationsDisabled) {
      return _StaticInteractiveCard(
        onTap: onTap!,
        elevation: computedElevation,
        radius: computedRadius,
        child: card,
      );
    }

    return _AnimatedInteractiveCard(
      onTap: onTap!,
      elevation: computedElevation,
      radius: computedRadius,
      child: card,
    );
  }
}

// -------------------------------------------------------------------------
// _StaticInteractiveCard — tappable card without animations
// -------------------------------------------------------------------------

class _StaticInteractiveCard extends StatelessWidget {
  const _StaticInteractiveCard({
    required this.onTap,
    required this.elevation,
    required this.radius,
    required this.child,
  });

  final VoidCallback onTap;
  final double elevation;
  final BorderRadius radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: radius,
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: radius, child: child),
    );
  }
}

// -------------------------------------------------------------------------
// _AnimatedInteractiveCard — hover + press wrapper for tappable cards
// -------------------------------------------------------------------------

class _AnimatedInteractiveCard extends StatefulWidget {
  const _AnimatedInteractiveCard({
    required this.onTap,
    required this.elevation,
    required this.radius,
    required this.child,
  });

  final VoidCallback onTap;
  final double elevation;
  final BorderRadius radius;
  final Widget child;

  @override
  State<_AnimatedInteractiveCard> createState() =>
      _AnimatedInteractiveCardState();
}

class _AnimatedInteractiveCardState extends State<_AnimatedInteractiveCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveElevation = _isHovered
        ? (widget.elevation + 1.0)
        : widget.elevation;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          transform: Matrix4.identity()
            ..translateByDouble(0.0, _isHovered ? -2.0 : 0.0, 0.0, 1.0),
          child: AnimatedScale(
            scale: _isPressed ? 0.98 : 1.0,
            duration: AppDurations.fast,
            curve: AppCurves.standard,
            child: Material(
              elevation: effectiveElevation,
              borderRadius: widget.radius,
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: widget.radius,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

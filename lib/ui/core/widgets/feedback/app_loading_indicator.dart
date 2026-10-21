import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:flutter/material.dart";

/// Defines the visual style of the loading indicator.
enum AppLoadingIndicatorVariant {
  /// Circular spinner style using [CircularProgressIndicator].
  circular,

  /// Pulsing dot style with scale animation.
  pulse,
}

/// The single spinner implementation behind every loading affordance in the
/// app — [AppLoading] and [AppLoadingIndicator] are thin wrappers over it.
///
/// [size] controls the width/height, [strokeWidth] the circular arc thickness
/// and [color] the tint (defaults to the theme primary color).
///
/// Example:
/// ```dart
/// const AppSpinner(size: 20, strokeWidth: 2)
/// ```
class AppSpinner extends StatelessWidget {
  /// Creates an [AppSpinner].
  const AppSpinner({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
    this.variant = AppLoadingIndicatorVariant.circular,
  });

  /// The size of the indicator (width and height).
  final double size;

  /// The stroke width used for the circular variant.
  final double strokeWidth;

  /// The color of the indicator. Defaults to the theme primary color.
  final Color? color;

  /// The visual variant of the indicator.
  final AppLoadingIndicatorVariant variant;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: switch (variant) {
        AppLoadingIndicatorVariant.circular => CircularProgressIndicator(
          color: resolved,
          strokeWidth: strokeWidth,
        ),
        AppLoadingIndicatorVariant.pulse => _PulseIndicator(
          size: size,
          color: resolved,
        ),
      },
    );
  }
}

/// A stateless loading indicator widget that displays either a circular
/// spinner or a pulsing dot based on the [variant] parameter.
///
/// Thin wrapper over [AppSpinner]. [size] controls the dimensions of the
/// indicator, [color] sets the indicator color (defaults to the theme primary
/// color) and [strokeWidth] is used for the circular variant (defaults to 3).
///
/// Example:
/// ```dart
/// AppLoadingIndicator(
///   size: 32,
///   variant: AppLoadingIndicatorVariant.pulse,
/// )
/// ```
class AppLoadingIndicator extends StatelessWidget {
  /// The size of the indicator (width and height).
  final double size;

  /// The color of the indicator.
  final Color? color;

  /// The visual variant of the indicator.
  final AppLoadingIndicatorVariant variant;

  /// The stroke width used for the circular variant.
  final double strokeWidth;

  /// Creates an [AppLoadingIndicator] with default values.
  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.variant = AppLoadingIndicatorVariant.circular,
    this.strokeWidth = 3,
  });

  /// Creates a circular loading indicator.
  const AppLoadingIndicator.circular({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
  }) : variant = AppLoadingIndicatorVariant.circular;

  /// Creates a pulsing dot loading indicator.
  const AppLoadingIndicator.pulse({super.key, this.size = 24, this.color})
    : variant = AppLoadingIndicatorVariant.pulse,
      strokeWidth = 3;

  @override
  Widget build(BuildContext context) {
    return AppSpinner(
      size: size,
      strokeWidth: strokeWidth,
      color: color,
      variant: variant,
    );
  }
}

/// Internal stateful widget that renders a pulsing dot animation.
///
/// Uses [AnimationController.repeat(reverse: true)] to achieve continuous
/// 0.6 -> 1.0 -> 0.6 scale loop. When animations are disabled via [MediaQuery],
/// renders a static circle without creating an AnimationController.
class _PulseIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const _PulseIndicator({required this.size, required this.color});

  @override
  State<_PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<_PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.long);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = SizedBox(
      width: widget.size,
      height: widget.size,
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );

    if (MediaQuery.of(context).disableAnimations) return dot;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          Transform.scale(scale: 0.6 + 0.4 * _controller.value, child: child),
      child: dot,
    );
  }
}

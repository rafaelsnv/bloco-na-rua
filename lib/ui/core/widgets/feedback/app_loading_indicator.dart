import "package:flutter/material.dart";

import "../../tokens/app_duration.dart";

import "../../tokens/app_colors.dart";

/// Defines the visual style of the loading indicator.
enum AppLoadingIndicatorVariant {
  /// Circular spinner style using [CircularProgressIndicator].
  circular,

  /// Pulsing dot style with scale animation.
  pulse,
}

/// A stateless loading indicator widget that displays either a circular
/// spinner or a pulsing dot based on the [variant] parameter.
///
/// [size] controls the dimensions of the indicator.
/// [color] sets the indicator color (defaults to [AppColors.primary]).
/// [strokeWidth] is used for the circular variant (defaults to 3).
///
/// Example:
/// ```dart
/// AppLoadingIndicator(
///   size: 32,
///   color: AppColors.accent,
///   variant: AppLoadingIndicatorVariant.pulse,
/// )
/// ```
class AppLoadingIndicator extends StatelessWidget {
  /// The size of the indicator (width and height).
  final double size;

  /// The color of the indicator.
  /// Defaults to [AppColors.primary].
  final Color? color;

  /// The visual variant of the indicator.
  final AppLoadingIndicatorVariant variant;

  /// The stroke width used for the circular variant.
  /// Only applies when [variant] is [AppLoadingIndicatorVariant.circular].
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
    return SizedBox(width: size, height: size, child: _buildIndicator(context));
  }

  Widget _buildIndicator(BuildContext context) {
    switch (variant) {
      case AppLoadingIndicatorVariant.circular:
        return CircularProgressIndicator(
          color: color ?? AppColors.primary,
          strokeWidth: strokeWidth,
        );
      case AppLoadingIndicatorVariant.pulse:
        return _PulseIndicator(size: size, color: color ?? AppColors.primary);
    }
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
    if (MediaQuery.of(context).disableAnimations) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 0.6 + 0.4 * _controller.value;
        return Transform.scale(scale: scale, child: child);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// Full-screen loading state widget.
//
// Displays a centered spinner with an optional message below.
// Respects [MediaQuery.disableAnimationsOf(context)] by showing
// a static hourglass icon instead of the spinning indicator.

import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "../../tokens/app_spacing.dart";
import "../../tokens/app_typography.dart";

/// Full-screen centered loading indicator.
///
/// Displays a [CircularProgressIndicator] (or a static hourglass icon when
/// animations are disabled) with an optional [message] below it.
///
/// Example:
/// ```dart
/// if (state.status == Status.loading) {
///   return const AppLoading(message: "Carregando blocos...");
/// }
/// ```
class AppLoading extends StatelessWidget {
  /// Creates an [AppLoading] widget.
  ///
  /// [message] is optional; when provided, it is displayed below the spinner.
  /// [size] controls the size of the spinner or static icon, in pixels.
  const AppLoading({super.key, this.message, this.size = 40});

  /// Optional loading message displayed below the spinner.
  final String? message;

  /// Size of the spinner or static icon, in pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final animationsDisabled = MediaQuery.of(context).disableAnimations;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            animationsDisabled
                ? Icon(
                    Icons.hourglass_top_rounded,
                    size: size,
                    color: AppColors.primary,
                  )
                : SizedBox(
                    width: size,
                    height: size,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                  ),
            if (message != null) ...[
              const SizedBox(height: Spacing.space_md),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

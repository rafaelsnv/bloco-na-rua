import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_loading_indicator.dart";
import "package:flutter/material.dart";

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
  /// [strokeWidth] controls the thickness of the spinner arc.
  const AppLoading({
    super.key,
    this.message,
    this.size = 40,
    this.strokeWidth = 3,
  });

  /// Optional loading message displayed below the spinner.
  final String? message;

  /// Size of the spinner or static icon, in pixels.
  final double size;

  /// Stroke width of the spinner arc.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final animationsDisabled = MediaQuery.of(context).disableAnimations;
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            animationsDisabled
                ? Icon(Icons.hourglass_top_rounded, size: size, color: primary)
                : AppSpinner(
                    size: size,
                    strokeWidth: strokeWidth,
                    color: primary,
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

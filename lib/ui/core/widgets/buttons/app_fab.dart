import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:flutter/material.dart";

/// Color variants for [AppFAB].
enum AppFabColor {
  /// Primary violet — brand primary.
  primary,

  /// Accent orange — call-to-action.
  accent,

  /// Tertiary teal — presence/online indicators.
  tertiary,
}

/// A design-system-compliant FAB widget supporting basic and extended variants,
/// using [FloatingActionButton] which provides native press feedback.
class AppFAB extends StatelessWidget {
  /// Creates an [AppFAB].
  ///
  /// [icon] is required and specifies the [IconData] to display.
  ///
  /// [onPressed] is required and called when the FAB is tapped.
  ///
  /// [label] optionally provides a label text. When non-null the FAB renders
  /// as an ExtendedFloatingActionButton; when null it renders as a basic FAB.
  ///
  /// [size] defaults to [AppFabSizeMetrics.md] (48px diameter).
  ///
  /// [fabColor] defaults to [AppFabColor.accent] (orange).
  ///
  /// [child] overrides [icon] when non-null — useful for inline loading
  /// indicators. Pair with `onPressed: null` to disable interaction.
  const AppFAB({
    required this.icon,
    required this.onPressed,
    this.label,
    this.child,
    this.size = AppFabSizeMetrics.md,
    this.fabColor = AppFabColor.accent,
    super.key,
  });

  /// The icon to display on the FAB. Ignored if [child] is provided.
  final IconData icon;

  /// Callback when the FAB is tapped. Null disables interaction (e.g. loading).
  final VoidCallback? onPressed;

  /// Optional label text. When non-null the FAB is rendered as
  /// ExtendedFloatingActionButton; when null it is a basic FAB.
  final String? label;

  /// Size preset pulling all metrics from [AppFabSizeMetrics].
  final AppFabSizeMetrics size;

  /// Color variant controlling the FAB background color.
  final AppFabColor fabColor;

  /// Optional override for the FAB's child widget (e.g. a spinner).
  final Widget? child;

  // Standard FAB elevation.
  static const double _elevationDefault = 6.0;

  // ponytail: FAB primary uses light variant in dark mode for better contrast on dark surface
  Color _backgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (fabColor) {
      AppFabColor.primary => colorScheme.primary,
      AppFabColor.accent => AppColors.accent,
      AppFabColor.tertiary => colorScheme.tertiary,
    };
  }

  Color _foregroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveKey = key ?? Key('app_fab_$label');
    return label == null
        ? _buildBasicFab(context, effectiveKey)
        : _buildExtendedFab(context, effectiveKey);
  }

  Widget _buildBasicFab(BuildContext context, Key effectiveKey) {
    return SizedBox(
      width: size.diameter,
      height: size.diameter,
      child: FloatingActionButton(
        key: effectiveKey,
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: _backgroundColor(context),
        foregroundColor: _foregroundColor(context),
        elevation: _elevationDefault,
        shape: RoundedRectangleBorder(borderRadius: Radii.fab),
        heroTag: null,
        child: child ?? Icon(icon, size: size.iconSize),
      ),
    );
  }

  Widget _buildExtendedFab(BuildContext context, Key effectiveKey) {
    return FloatingActionButton.extended(
      key: effectiveKey,
      onPressed: onPressed,
      backgroundColor: _backgroundColor(context),
      foregroundColor: _foregroundColor(context),
      elevation: _elevationDefault,
      shape: RoundedRectangleBorder(borderRadius: Radii.fab),
      heroTag: null,
      icon: Icon(icon, size: size.iconSize),
      label: Text(label!),
    );
  }
}

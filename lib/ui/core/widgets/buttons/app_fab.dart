import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:flutter/material.dart";

/// Size variants for [AppFAB].
enum AppFabSize {
  /// Small: 40px diameter.
  sm,

  /// Medium: 56px diameter.
  md,

  /// Large: 72px diameter.
  lg,
}

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
  /// [size] defaults to [AppFabSize.md] (56px).
  ///
  /// [fabColor] defaults to [AppFabColor.accent] (orange).
  const AppFAB({
    required this.icon,
    required this.onPressed,
    this.label,
    this.size = AppFabSize.md,
    this.fabColor = AppFabColor.accent,
    super.key,
  });

  /// The icon to display on the FAB.
  final IconData icon;

  /// Callback when the FAB is tapped.
  final VoidCallback onPressed;

  /// Optional label text. When non-null the FAB is rendered as
  /// ExtendedFloatingActionButton; when null it is a basic FAB.
  final String? label;

  /// Size preset controlling the FAB diameter.
  final AppFabSize size;

  /// Color variant controlling the FAB background color.
  final AppFabColor fabColor;

  static const Map<AppFabSize, double> _sizeTokens = {
    AppFabSize.sm: 40.0,
    AppFabSize.md: 56.0,
    AppFabSize.lg: 72.0,
  };

  static const Map<AppFabSize, double> _iconSizeTokens = {
    AppFabSize.sm: 20.0,
    AppFabSize.md: 24.0,
    AppFabSize.lg: 28.0,
  };

  // Standard FAB elevation.
  static const double _elevationDefault = 6.0;

  double get _diameter => _sizeTokens[size]!;
  double get _iconSize => _iconSizeTokens[size]!;

  Color get _backgroundColor => switch (fabColor) {
    AppFabColor.primary => AppColors.primary,
    AppFabColor.accent => AppColors.accent,
    AppFabColor.tertiary => AppColors.tertiary,
  };

  @override
  Widget build(BuildContext context) {
    final effectiveKey = key ?? Key('app_fab_$label');
    return label == null
        ? _buildBasicFab(context, effectiveKey)
        : _buildExtendedFab(context, effectiveKey);
  }

  Widget _buildBasicFab(BuildContext context, Key effectiveKey) {
    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: FloatingActionButton(
        key: effectiveKey,
        onPressed: onPressed,
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        elevation: _elevationDefault,
        shape: RoundedRectangleBorder(borderRadius: Radii.fab),
        heroTag: null,
        child: Icon(icon, size: _iconSize),
      ),
    );
  }

  Widget _buildExtendedFab(BuildContext context, Key effectiveKey) {
    return FloatingActionButton.extended(
      key: effectiveKey,
      onPressed: onPressed,
      backgroundColor: _backgroundColor,
      foregroundColor: Colors.white,
      elevation: _elevationDefault,
      shape: RoundedRectangleBorder(borderRadius: Radii.fab),
      heroTag: null,
      icon: Icon(icon, size: _iconSize),
      label: Text(label!),
    );
  }
}

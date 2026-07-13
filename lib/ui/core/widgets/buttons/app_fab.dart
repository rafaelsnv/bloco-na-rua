// lib/ui/core/widgets/buttons/app_fab.dart
//
// Bloco na Rua design system Floating Action Button component.
//
// Variants:
//   - Basic FAB:  Rendered when [label] is null.
//   - Extended FAB: Rendered when [label] is non-null — shows icon + label.
//
// State behaviour:
//   - Press:     AnimatedScale to 0.95 + opacity 0.9.
//   - Hover:     Opacity 0.9 (layout-safe, no scale transform).
//   - Animations are disabled when MediaQuery.disableAnimationsOf(context) is true.

import "package:flutter/material.dart";

import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";

/// Size variants for [AppFAB].
enum AppFabSize {
  /// Small: 40px diameter.
  sm,

  /// Medium: 56px diameter.
  md,

  /// Large: 72px diameter.
  lg,
}

/// A design-system-compliant FAB widget supporting basic and extended variants,
/// with press and hover feedback, respecting accessibility animation preferences.
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
  const AppFAB({
    required this.icon,
    required this.onPressed,
    this.label,
    this.size = AppFabSize.md,
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

  // -------------------------------------------------------------------------
  // Size tokens
  // -------------------------------------------------------------------------

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

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);

    final fab = label == null
        ? _buildBasicFab(context)
        : _buildExtendedFab(context);

    if (animationsDisabled) {
      return fab;
    }

    return _PressFeedbackWrapper(child: fab);
  }

  Widget _buildBasicFab(BuildContext context) {
    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.cta,
        foregroundColor: Colors.white,
        elevation: _elevationDefault,
        shape: RoundedRectangleBorder(borderRadius: Radii.fab),
        heroTag: null,
        child: Icon(icon, size: _iconSize),
      ),
    );
  }

  Widget _buildExtendedFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.cta,
      foregroundColor: Colors.white,
      elevation: _elevationDefault,
      shape: RoundedRectangleBorder(borderRadius: Radii.fab),
      heroTag: null,
      icon: Icon(icon, size: _iconSize),
      label: Text(label!),
    );
  }
}

// -------------------------------------------------------------------------
// _PressFeedbackWrapper — press scale + opacity feedback
// -------------------------------------------------------------------------

class _PressFeedbackWrapper extends StatefulWidget {
  const _PressFeedbackWrapper({required this.child});

  final Widget child;

  @override
  State<_PressFeedbackWrapper> createState() => _PressFeedbackWrapperState();
}

class _PressFeedbackWrapperState extends State<_PressFeedbackWrapper> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        duration: AppDurations.fast,
        curve: AppCurves.standard,
        scale: _isPressed ? 0.95 : 1.0,
        child: AnimatedOpacity(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          opacity: _isPressed ? 0.9 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}

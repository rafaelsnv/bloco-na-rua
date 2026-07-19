import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_fab.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// A FAB that expands into a speed-dial menu for creating or joining a block.
///
/// [isExpanded] controls the expanded/collapsed visual state.
///
/// [onFabPressed] is called when the FAB itself is tapped (to toggle expansion).
/// Outside-tap dismiss is handled by the caller (screen) via [onExpandedChanged].
///
/// Uses an in-screen expansion pattern instead of showModalBottomSheet to avoid
/// navigation conflicts with StatefulNavigationShell.goBranch.
class AddBlockFab extends StatefulWidget {
  const AddBlockFab({
    super.key,
    required this.isExpanded,
    required this.onFabPressed,
    this.shouldAnimate = true,
    this.onExpandedChanged,
  });

  /// Whether the speed-dial menu is currently expanded.
  final bool isExpanded;

  /// Called when the FAB is tapped (to toggle expansion).
  final VoidCallback onFabPressed;

  /// Whether animations should play on expand/collapse.
  /// Set to false for instant collapse during navigation transitions.
  final bool shouldAnimate;

  /// Called whenever the expansion state changes.
  final ValueChanged<bool>? onExpandedChanged;

  @override
  State<AddBlockFab> createState() => _AddBlockFabState();
}

class _AddBlockFabState extends State<AddBlockFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: widget.shouldAnimate ? AppDurations.slower : AppDurations.instant,
      vsync: this,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _rotation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant AddBlockFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      if (widget.isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    }
    if (oldWidget.shouldAnimate != widget.shouldAnimate) {
      _rotationController.duration = widget.shouldAnimate
          ? AppDurations.slower
          : AppDurations.instant;
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _navigate(String route) {
    widget.onExpandedChanged?.call(false);
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final duration =
        widget.shouldAnimate ? AppDurations.slower : AppDurations.instant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Entrar em Bloco
        _SpeedDialAction(
          label: "Entrar em Bloco",
          icon: Icons.group_add_rounded,
          expanded: widget.isExpanded,
          duration: duration,
          onTap: () => _navigate(Routes.joinBlock),
        ),
        if (widget.isExpanded) SizedBox(height: Spacing.space_sm),
        // Criar Bloco
        _SpeedDialAction(
          label: "Criar Bloco",
          icon: Icons.add_rounded,
          expanded: widget.isExpanded,
          duration: duration,
          onTap: () => _navigate(Routes.createBlock),
        ),
        if (widget.isExpanded) SizedBox(height: Spacing.space_md),
        // Main FAB — scale + rotation animation
        AnimatedScale(
          scale: widget.isExpanded ? 1.0 : 0.8,
          duration: duration,
          curve: Curves.easeOutBack,
          child: RotationTransition(
            turns: _rotation,
            child: AppFAB(
              icon: Icons.add_rounded,
              onPressed: widget.onFabPressed,
              fabColor: AppFabColor.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SpeedDialAction extends StatelessWidget {
  const _SpeedDialAction({
    required this.label,
    required this.icon,
    required this.expanded,
    required this.duration,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool expanded;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: expanded ? 1.0 : 0.5,
      duration: duration,
      curve: Curves.easeOutBack,
      child: AnimatedSlide(
        offset: expanded ? Offset.zero : const Offset(0, 0.5),
        duration: duration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: expanded ? 1 : 0,
          duration: duration,
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 20),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: Radii.radiusLg),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.space_md,
                vertical: Spacing.space_sm,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

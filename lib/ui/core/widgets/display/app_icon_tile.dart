import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";

/// A single icon rendered inside a tinted rounded box.
///
/// This is the one place the "icon on a colored tile" pattern is built, so
/// every screen that shows an icon badge (block header, list tile leading
/// icon, meeting card) renders the same shape.
///
/// The corner radius defaults to a third of [size] (a soft squircle-ish
/// rounding); pass an explicit [radius] to override it — e.g.
/// `radius: size / 2` for a circle.
///
/// The icon ink defaults to [AppColors.inkFor] of [backgroundColor], so the
/// glyph stays readable on any tint.
///
/// Example:
/// ```dart
/// AppIconTile(
///   icon: Icons.event_rounded,
///   backgroundColor: colorScheme.primaryContainer,
///   size: AppIconSizes.displayLarge,
///   radius: 22, // circle
///   iconSize: AppIconSizes.xl,
/// )
/// ```
class AppIconTile extends StatelessWidget {
  /// Creates an [AppIconTile].
  const AppIconTile({
    super.key,
    required this.icon,
    required this.backgroundColor,
    this.size = AppIconSizes.display,
    this.radius,
    this.iconSize = AppIconSizes.lg,
    this.foregroundColor,
  });

  /// The glyph rendered in the center of the tile.
  final IconData icon;

  /// Fill color of the tile (usually a container/tint color).
  final Color backgroundColor;

  /// Edge length of the square tile, in logical pixels.
  final double size;

  /// Corner radius of the tile. Defaults to `size / 3`.
  final double? radius;

  /// Size of the icon glyph, in logical pixels.
  final double iconSize;

  /// Ink color of the glyph. Defaults to [AppColors.inkFor] of
  /// [backgroundColor].
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final ink = foregroundColor ?? AppColors.inkFor(backgroundColor);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius ?? size / 3),
      ),
      child: Icon(icon, size: iconSize, color: ink),
    );
  }
}

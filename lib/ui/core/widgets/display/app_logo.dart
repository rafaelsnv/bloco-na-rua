import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/material.dart";

/// The Bloco na Rua brand mark — a fanfare horn inside a gold sunburst,
/// on a rounded violet tile.
///
/// Ships as a packaged raster (`assets/logo/`) rather than an SVG so the app
/// needs no extra dependency to render it. The light and dark variants are the
/// same artwork with the tile and subject colours swapped, picked automatically
/// from the theme brightness.
class AppLogo extends StatelessWidget {
  /// Creates an [AppLogo].
  ///
  /// [size] is the edge length of the square mark in logical pixels.
  const AppLogo({this.size = AppIconSizes.xxl, super.key});

  /// Edge length of the square mark in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      isDark ? "assets/logo/logo_mark_dark.png" : "assets/logo/logo_mark.png",
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
    );
  }
}

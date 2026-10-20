import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

/// A design-system-compliant app bar widget that implements [PreferredSizeWidget].
///
/// Uses [AppTypography.titleLarge] for the title and respects the design system
/// color and spacing tokens. Automatically shows a back button when [canPop] is
/// true and [showBackButton] is true.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AppAppBar].
  ///
  /// [title] is required and displayed using [AppTypography.titleLarge].
  ///
  /// [leading] is used as the leading widget. When null and [showBackButton] is
  /// true and [canPop] is true, a default back button is shown.
  ///
  /// [actions] are placed at the trailing edge of the app bar, each wrapped
  /// with [Spacing.space_2xs] right padding.
  const AppAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.showBackButton = true,
    this.bottom,
    super.key,
  });

  /// The title string displayed in the app bar.
  final String title;

  /// An optional widget to display before the title.
  ///
  /// When null and [showBackButton] is true and the navigator can pop, a
  /// default back button is shown.
  final Widget? leading;

  /// Optional widgets to display at the trailing edge of the app bar.
  ///
  /// Each action is wrapped with [Spacing.space_2xs] right padding.
  final List<Widget>? actions;

  /// Whether the title should be centered. Defaults to false.
  final bool centerTitle;

  /// Override for the background color. Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Override for the foreground (icon and title) color.
  /// Defaults to [ColorScheme.onSurface].
  final Color? foregroundColor;

  /// Elevation for the app bar. Defaults to 0.
  final double? elevation;

  /// When false, no back button is shown even if the navigator can pop.
  /// Defaults to true.
  final bool showBackButton;

  /// Optional [PreferredSizeWidget] displayed below the app bar, such as a tab bar.
  final PreferredSizeWidget? bottom;

  // -------------------------------------------------------------------------
  // PreferredSizeWidget implementation
  // -------------------------------------------------------------------------

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ??
        theme.appBarTheme.backgroundColor ??
        theme.colorScheme.surface;
    final effectiveForegroundColor =
        foregroundColor ??
        theme.appBarTheme.foregroundColor ??
        theme.colorScheme.onSurfaceVariant;

    final List<Widget>? effectiveActions = _buildActions();

    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showBackButton && leading == null,
      leading: leading,
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(
          color: effectiveForegroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: effectiveActions,
      bottom: bottom,
    );
  }

  List<Widget>? _buildActions() {
    if (actions == null || actions!.isEmpty) {
      return null;
    }

    return actions!.map((action) {
      return Padding(
        padding: const EdgeInsets.only(right: Spacing.space_2xs),
        child: action,
      );
    }).toList();
  }
}

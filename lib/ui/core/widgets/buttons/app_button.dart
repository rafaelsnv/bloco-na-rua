import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

/// Button variant taxonomy.
enum AppButtonVariant {
  /// Brand primary violet fill — main call-to-action.
  primary,

  /// Brand secondary rose outline — secondary actions.
  secondary,

  /// Accent orange fill — call-to-action (e.g. "Entrar no Bloco", "Salvar").
  /// Renders bold with elevation shadow and 12px (rounded-xl) radius.
  accent,

  /// Surface fill — low-emphasis actions.
  tertiary,

  /// Transparent fill — inline or tertiary actions.
  ghost,
}

/// Button size taxonomy with associated sizing tokens.
enum AppButtonSize {
  /// Small: 36px height, 8px horizontal padding, 12px vertical padding.
  sm,

  /// Medium: 44px height, 12px horizontal padding, 16px vertical padding.
  md,

  /// Large: 52px height, 16px horizontal padding, 20px vertical padding.
  lg,
}

/// A design-system-compliant button widget supporting four visual variants,
/// three size presets, loading and disabled states, and icon decoration.
class AppButton extends StatelessWidget {
  /// Creates an AppButton.
  ///
  /// All parameters follow the design system token conventions.
  const AppButton({
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    super.key,
  });

  /// The primary text label displayed on the button.
  final String label;

  /// Visual style preset. Defaults to [AppButtonVariant.primary].
  final AppButtonVariant variant;

  /// Size preset controlling height and padding.
  final AppButtonSize size;

  /// Optional leading icon rendered before the label.
  final Widget? icon;

  /// Optional trailing icon rendered after the label.
  final Widget? trailingIcon;

  /// Callback fired when the button is tapped. Set to null when
  /// [isDisabled] is true.
  final VoidCallback? onPressed;

  /// When true the label is replaced by a 20px CircularProgressIndicator.
  final bool isLoading;

  /// When true applies 0.5 opacity and sets [onPressed] to null.
  final bool isDisabled;

  /// When true the button expands to fill its parent's width.
  final bool isFullWidth;

  static const Map<AppButtonSize, double> _heightTokens = {
    AppButtonSize.sm: 36.0,
    AppButtonSize.md: 44.0,
    AppButtonSize.lg: 52.0,
  };

  static const Map<AppButtonSize, double> _horizontalPaddingTokens = {
    AppButtonSize.sm: Spacing.space_2xs,
    AppButtonSize.md: Spacing.space_xs,
    AppButtonSize.lg: Spacing.space_sm,
  };

  static const Map<AppButtonSize, double> _verticalPaddingTokens = {
    AppButtonSize.sm: Spacing.space_xs,
    AppButtonSize.md: Spacing.space_sm,
    AppButtonSize.lg: 20.0,
  };

  static const Map<AppButtonSize, double> _iconLabelGapTokens = {
    AppButtonSize.sm: Spacing.space_2xs,
    AppButtonSize.md: Spacing.space_2xs,
    AppButtonSize.lg: Spacing.space_xs,
  };

  static const Map<AppButtonSize, double> _iconSizeTokens = {
    AppButtonSize.sm: 16.0,
    AppButtonSize.md: 20.0,
    AppButtonSize.lg: 24.0,
  };

  Color _foregroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return isDark ? AppColors.secondaryLight : AppColors.secondary;
      case AppButtonVariant.accent:
        return isDark ? AppColors.accentDark : Colors.white;
      case AppButtonVariant.tertiary:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
      case AppButtonVariant.ghost:
        return isDark ? AppColors.primaryLight : AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = _heightTokens[size]!;
    final horizontalPadding = _horizontalPaddingTokens[size]!;
    final verticalPadding = _verticalPaddingTokens[size]!;
    final iconLabelGap = _iconLabelGapTokens[size]!;
    final iconSize = _iconSizeTokens[size]!;
    final effectiveOnPressed = isDisabled ? null : onPressed;
    final effectiveOpacity = isDisabled ? 0.5 : 1.0;

    final animationsDisabled = MediaQuery.disableAnimationsOf(context);

    final content = _buildContent(
      context,
      effectiveOpacity,
      iconLabelGap,
      iconSize,
    );

    final buttonChild = _buildButtonChild(
      context,
      content,
      height,
      horizontalPadding,
      verticalPadding,
      effectiveOnPressed,
      effectiveOpacity,
      animationsDisabled,
    );

    if (animationsDisabled) {
      return buttonChild;
    }

    return _HoverOpacityWrapper(
      opacity: effectiveOpacity,
      child: _PressScaleWrapper(child: buttonChild),
    );
  }

  Widget _buildContent(
    BuildContext context,
    double opacity,
    double iconLabelGap,
    double iconSize,
  ) {
    final foreground = _foregroundColor(context);

    return Opacity(
      opacity: opacity,
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!, // ignore: use_null_aware_elements
          if (icon != null && (isLoading || label.isNotEmpty))
            SizedBox(width: iconLabelGap),
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foreground),
              ),
            )
          else if (label.isNotEmpty)
            Text(label, style: _textStyle(context, foreground)),
          if (trailingIcon != null && (isLoading || label.isNotEmpty))
            SizedBox(width: iconLabelGap),
          ?trailingIcon,
        ],
      ),
    );
  }

  Widget _buildButtonChild(
    BuildContext context,
    Widget content,
    double height,
    double horizontalPadding,
    double verticalPadding,
    VoidCallback? effectiveOnPressed,
    double effectiveOpacity,
    bool animationsDisabled,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = _foregroundColor(context);
    final minimumSize = Size.fromHeight(height);
    final padding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
    final textStyle = _textStyle(context, foreground);

    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(minimumSize),
      padding: WidgetStateProperty.all(padding),
      textStyle: WidgetStateProperty.all(textStyle),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: Radii.button),
      ),
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(AppColors.primary),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
        child: content,
      ),
      AppButtonVariant.accent => FilledButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(
            isDark ? AppColors.accentLight : AppColors.accent,
          ),
          foregroundColor: WidgetStateProperty.all(foreground),
          elevation: WidgetStateProperty.all(isDark ? 0.0 : 6.0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: Radii.radiusMd),
          ),
        ),
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(AppColors.secondary),
          side: WidgetStateProperty.all(
            BorderSide(color: AppColors.secondary, width: 1.5),
          ),
        ),
        child: content,
      ),
      AppButtonVariant.tertiary => FilledButton.tonal(
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(foreground),
        ),
        child: content,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(foreground),
        ),
        child: content,
      ),
    };

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  TextStyle _textStyle(BuildContext context, Color foreground) {
    final base = switch (variant) {
      AppButtonVariant.accent => AppTypography.buttonLarge.copyWith(
        fontWeight: FontWeight.w700,
      ),
      _ => switch (size) {
        AppButtonSize.sm => AppTypography.buttonSmall,
        AppButtonSize.md => AppTypography.buttonMedium,
        AppButtonSize.lg => AppTypography.buttonLarge,
      },
    };
    return base.copyWith(color: foreground);
  }
}

class _HoverOpacityWrapper extends StatefulWidget {
  const _HoverOpacityWrapper({required this.opacity, required this.child});

  final double opacity;
  final Widget child;

  @override
  State<_HoverOpacityWrapper> createState() => _HoverOpacityWrapperState();
}

class _HoverOpacityWrapperState extends State<_HoverOpacityWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedOpacity(
        duration: AppDurations.fast,
        curve: AppCurves.standard,
        opacity: _isHovered ? widget.opacity * 0.9 : widget.opacity,
        child: widget.child,
      ),
    );
  }
}

class _PressScaleWrapper extends StatefulWidget {
  const _PressScaleWrapper({required this.child});

  final Widget child;

  @override
  State<_PressScaleWrapper> createState() => _PressScaleWrapperState();
}

class _PressScaleWrapperState extends State<_PressScaleWrapper> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        curve: AppCurves.standard,
        child: widget.child,
      ),
    );
  }
}

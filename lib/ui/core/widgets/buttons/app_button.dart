import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:flutter/material.dart";

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

/// A design-system-compliant button widget supporting four visual variants,
/// three size presets, loading and disabled states, and icon decoration.
class AppButton extends StatelessWidget {
  /// Creates an AppButton.
  ///
  /// All parameters follow the design system token conventions.
  const AppButton({
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSizeMetrics.md,
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

  /// Size preset pulling all metrics from [AppButtonSizeMetrics].
  final AppButtonSizeMetrics size;

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

  Color _foregroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return colorScheme.secondary;
      case AppButtonVariant.accent:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return isDark ? AppColors.textOnPrimaryDark : AppColors.textOnPrimary;
      case AppButtonVariant.tertiary:
        return colorScheme.onSurface;
      case AppButtonVariant.ghost:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isDisabled ? null : onPressed;
    final effectiveOpacity = isDisabled ? 0.5 : 1.0;
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);

    final content = _buildContent(context);
    final buttonChild = _buildButtonChild(
      context,
      content,
      effectiveOnPressed,
      effectiveOpacity,
      animationsDisabled,
      key ?? Key('app_button_$label'),
    );

    if (animationsDisabled) return buttonChild;
    return _HoverOpacityWrapper(
      opacity: 1.0,
      child: _PressScaleWrapper(child: buttonChild),
    );
  }

  Widget _buildContent(BuildContext context) {
    final foreground = _foregroundColor(context);
    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) icon!,
        if (icon != null && (isLoading || label.isNotEmpty))
          SizedBox(width: size.iconLabelGap),
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
          SizedBox(width: size.iconLabelGap),
        ?trailingIcon,
      ],
    );
  }

  Widget _buildButtonChild(
    BuildContext context,
    Widget content,
    VoidCallback? effectiveOnPressed,
    double effectiveOpacity,
    bool animationsDisabled,
    Key effectiveKey,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = _foregroundColor(context);
    final minimumSize = Size.fromHeight(size.height);
    final padding = EdgeInsets.symmetric(
      horizontal: size.horizontalPadding,
      vertical: size.verticalPadding,
    );
    final textStyle = _textStyle(context, foreground);

    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(minimumSize),
      padding: WidgetStateProperty.all(padding),
      textStyle: WidgetStateProperty.all(textStyle),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: Radii.buttonPrimary),
      ),
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
        ),
        child: content,
      ),
      AppButtonVariant.accent => FilledButton(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.surfaceContainerHigh;
            }
            return isDark ? AppColors.accentLight : AppColors.accent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textTertiary;
            }
            return foreground;
          }),
          elevation: WidgetStateProperty.all(isDark ? 0.0 : 6.0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: Radii.buttonAccent),
          ),
        ),
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(foreground),
          side: WidgetStateProperty.all(
            BorderSide(color: foreground, width: 1.5),
          ),
        ),
        child: content,
      ),
      AppButtonVariant.tertiary => FilledButton.tonal(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(
            colorScheme.onSecondaryContainer,
          ),
        ),
        child: content,
      ),
      AppButtonVariant.ghost => TextButton(
        key: effectiveKey,
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: button,
    );
  }

  TextStyle _textStyle(BuildContext context, Color foreground) {
    final base = switch (variant) {
      AppButtonVariant.accent =>
        AppTypography.buttonLarge.copyWith(fontWeight: FontWeight.w700),
      _ => switch (size) {
          AppButtonSizeMetrics.sm => AppTypography.buttonSmall,
          AppButtonSizeMetrics.md => AppTypography.buttonMedium,
          AppButtonSizeMetrics.lg => AppTypography.buttonLarge,
          _ => AppTypography.buttonMedium,
        },
    };
    return base.copyWith(color: foreground);
  }
}

class _HoverOpacityWrapper extends StatefulWidget {
  const _HoverOpacityWrapper(
      {required this.opacity, required this.child});

  final double opacity;
  final Widget child;

  @override
  State<_HoverOpacityWrapper> createState() =>
      _HoverOpacityWrapperState();
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

import "package:bloco_na_rua/ui/core/theme/app_text_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_button_sizes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";
import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_loading_indicator.dart";
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

  /// When true sets [onPressed] to null. Visual disabled state is handled
  /// by the button variant's style (elevation, foreground opacity via M3).
  final bool isDisabled;

  /// When true the button expands to fill its parent's width.
  final bool isFullWidth;

  Color _foregroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        // Secondary ink is the brand primary (not the magenta `secondary`) —
        // the theme's outlinedButtonTheme already resolves it that way and
        // the widget used to override it back to magenta.
        return colorScheme.primary;
      case AppButtonVariant.accent:
        // Enabled: near-black ink on the orange fill, in BOTH modes.
        // Light: #1C1917 on #D97706 = 5.44:1. Dark: #1C1917 on #FBBF24 =
        // 9.53:1. Both pass WCAG AA (4.5:1) for the 16–18px label. The old
        // white ink (#FFFFFF on #D97706) was only 3.19:1 — a AA failure on
        // the app's primary CTA.
        // The disabled ink is resolved from the disabled fill instead, see
        // [_contentColor].
        return AppColors.textPrimary;
      case AppButtonVariant.tertiary:
        return colorScheme.onSurface;
      case AppButtonVariant.ghost:
        return colorScheme.primary;
    }
  }

  /// The fill this variant actually paints when disabled.
  ///
  /// Every filled variant drops to the neutral `surfaceContainerHigh` ramp,
  /// so a disabled control never keeps the brand colour and reads as
  /// enabled. Ghost paints no fill of its own — it has no disabled fill at
  /// all, so its ink does not come from one (see [_disabledInk]).
  Color _disabledFill(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.surfaceContainerHigh;
  }

  /// The ink a disabled control paints.
  ///
  /// Filled variants derive it FROM their disabled fill with
  /// `AppColors.inkFor`, so it can never drift from the fill it is painted
  /// on: near-black on the light fill (#1C1917 on #EDE9FE, ~14.7:1) and
  /// near-white on the dark fill (#FFFFFF on #3F4657, ~9.4:1). A pinned
  /// neutral token (textDisabled) could not do that — #64748B on the dark
  /// fill was only ~2.0:1.
  ///
  /// Ghost paints no fill, so a fill-derived ink would come from the page
  /// surface instead: near-black in light mode (#1C1917 on #FFFFFF, ~17.5:1)
  /// and near-white in dark (#FAFAF9 on #1F2937, ~14.1:1) — a DISABLED ghost
  /// would read as MORE prominent than an enabled one (the enabled brand ink
  /// is #7C3AED on #FFFFFF, ~5.7:1, in light and #A78BFA on #1F2937, ~5.4:1,
  /// in dark). Ghost therefore uses the theme's muted disabled ink: #A8A29E
  /// on #FFFFFF (~2.5:1) in light and #64748B on #1F2937 (~3.1:1) in dark.
  /// Disabled controls are WCAG-exempt.
  Color _disabledInk(BuildContext context) {
    if (variant == AppButtonVariant.ghost) {
      return Theme.of(context).extension<AppTextColors>()?.textDisabled ??
          AppColors.textDisabled;
    }
    return AppColors.inkFor(_disabledFill(context));
  }

  /// Color actually painted by the label/spinner, which overrides
  /// [ButtonStyle.foregroundColor] because [Text] merges its own color over
  /// the ambient default style. Resolving disabled here (not only in the style)
  /// is what makes the disabled label match the disabled fill (or, for ghost,
  /// the muted disabled ink).
  Color _contentColor(BuildContext context, bool disabled) {
    if (disabled) {
      return _disabledInk(context);
    }
    return _foregroundColor(context);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isDisabled ? null : onPressed;
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    // A null callback disables the button even when [isDisabled] is false
    // (the loading state of the logout button does exactly that), so the
    // disabled look is driven by the effective callback.
    final isDisabledState = effectiveOnPressed == null;

    final content = _buildContent(context, isDisabledState);
    final buttonChild = _buildButtonChild(
      context,
      content,
      effectiveOnPressed,
      animationsDisabled,
      key ?? Key('app_button_$label'),
    );

    if (animationsDisabled || isDisabled) return buttonChild;
    return _HoverOpacityWrapper(
      opacity: 1.0,
      child: _PressScaleWrapper(child: buttonChild),
    );
  }

  Widget _buildContent(BuildContext context, bool isDisabledState) {
    final foreground = _contentColor(context, isDisabledState);
    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ?icon,
        if (icon != null && (isLoading || label.isNotEmpty))
          SizedBox(width: size.iconLabelGap),
        if (isLoading)
          AppLoadingIndicator.circular(
            size: 20,
            strokeWidth: 2,
            color: foreground,
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

    // Disabled fill and the ink derived from it. Every filled variant
    // resolves the same pair, so the label can never drift from the fill it
    // sits on and a disabled control never keeps the brand colour. Ghost
    // paints no fill, so its ink comes from the theme's disabled ink
    // instead (see [_disabledInk]).
    final disabledFill = _disabledFill(context);
    final disabledInk = _disabledInk(context);

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
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledFill;
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledInk;
            }
            return foreground;
          }),
        ),
        child: content,
      ),
      AppButtonVariant.accent => FilledButton(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledFill;
            }
            return isDark ? AppColors.accentLight : AppColors.accent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledInk;
            }
            return foreground;
          }),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppElevation.none.value;
            }
            return isDark ? AppElevation.none.value : AppElevation.lg.value;
          }),
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
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledFill;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledInk;
            }
            return foreground;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              // The brand border is what made the disabled button look
              // clickable — it drops to the neutral outline token.
              return BorderSide(
                color: colorScheme.outline,
                width: Radii.outlineWidth,
              );
            }
            return BorderSide(color: foreground, width: Radii.outlineWidth);
          }),
        ),
        child: content,
      ),
      AppButtonVariant.tertiary => FilledButton.tonal(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledFill;
            }
            return colorScheme.secondaryContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledInk;
            }
            return colorScheme.onSecondaryContainer;
          }),
        ),
        child: content,
      ),
      AppButtonVariant.ghost => TextButton(
        key: effectiveKey,
        onPressed: effectiveOnPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledInk;
            }
            return foreground;
          }),
        ),
        child: content,
      ),
    };

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    // No hardcoded max width — the size metrics already own the height and
    // the padding; a magic 200px cap only clipped wide labels.
    return button;
  }

  TextStyle _textStyle(BuildContext context, Color foreground) {
    final base = switch (variant) {
      AppButtonVariant.accent => _largeLabel.copyWith(
        fontWeight: FontWeight.w700,
      ),
      _ => switch (size) {
        AppButtonSizeMetrics.sm => AppTypography.titleSmall,
        AppButtonSizeMetrics.md => AppTypography.titleMedium,
        AppButtonSizeMetrics.lg => _largeLabel,
        _ => AppTypography.titleMedium,
      },
    };
    return base.copyWith(color: foreground);
  }

  /// Label metrics for the large preset: 18px / w600 on a 24px line.
  ///
  /// Derived from [AppTypography.labelLarge] so the ladder stays on
  /// non-deprecated tokens while keeping the previous label size.
  static TextStyle get _largeLabel => AppTypography.labelLarge.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 24 / 18,
  );
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

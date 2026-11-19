import "package:flutter/material.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_elevation.dart";
import "package:bloco_na_rua/ui/core/theme/app_color_schemes.dart";
import "package:bloco_na_rua/ui/core/theme/app_text_colors.dart";
import "package:bloco_na_rua/ui/core/theme/app_text_themes.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/core/tokens/app_duration.dart";

class AppTheme {
  AppTheme._();

  /// Light theme built with Material 3 and the project ColorScheme and TextTheme.
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: const [AppTextColors.light],
      colorScheme: lightColorScheme,
      textTheme: lightTextTheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      hoverColor: AppColors.tint(lightColorScheme.primary),
      focusColor: AppColors.tint(lightColorScheme.primary, 0.12),
      appBarTheme: AppBarTheme(
        // D1: unified flat-surface app bar in both brightnesses, separated
        // from the content by a hairline instead of a filled brand block.
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: AppElevation.none.value,
        scrolledUnderElevation: AppElevation.none.value,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        // D4: the theme's headlineMedium is the canonical app bar title style.
        titleTextStyle: lightTextTheme.headlineMedium,
        shape: Border(
          bottom: BorderSide(
            color: lightColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightColorScheme.surface,
        elevation: AppElevation.sm.value,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.card,
          side: BorderSide(
            color: lightColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          // Mirrored from the dark theme so disabled states match across
          // brightnesses: ink derived from the disabled fill via inkFor.
          disabledBackgroundColor: lightColorScheme.surfaceContainerHigh,
          disabledForegroundColor: AppColors.inkFor(
            lightColorScheme.surfaceContainerHigh,
          ).withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // D5: violet ink + border; magenta is reserved for decorative fills.
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(
            color: lightColorScheme.primary,
            width: Radii.outlineWidth,
          ),
          disabledBackgroundColor: lightColorScheme.surfaceContainerHigh,
          disabledForegroundColor: AppColors.inkFor(
            lightColorScheme.surfaceContainerHigh,
          ).withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          disabledForegroundColor: AppColors.inkFor(
            lightColorScheme.surfaceContainerHigh,
          ).withValues(alpha: 0.38),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium.copyWith(
          color: lightColorScheme.onSurface,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.space_xs,
          vertical: Spacing.space_4xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.chip),
        selectedColor: AppColors.primary,
        backgroundColor: Colors.transparent,
        checkmarkColor: lightColorScheme.onPrimary,
        secondarySelectedColor: AppColors.primary,
        side: BorderSide(color: Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: lightColorScheme.primary,
        linearTrackColor: lightColorScheme.surfaceContainerHighest,
        circularTrackColor: lightColorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: lightColorScheme.onInverseSurface,
        ),
        actionTextColor: lightColorScheme.inversePrimary,
        disabledActionTextColor: lightColorScheme.onInverseSurface.withValues(
          alpha: 0.5,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: Radii.button),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        filled: true,
        fillColor: lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: lightColorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_md,
          vertical: Spacing.space_sm,
        ),
      ),
      iconTheme: IconThemeData(color: lightColorScheme.onSurfaceVariant),
      dividerTheme: DividerThemeData(
        color: lightColorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? lightColorScheme.primary
              : lightColorScheme.surfaceContainerHighest,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        // L16: the bottom nav surface is owned by the theme.
        backgroundColor: lightColorScheme.surface,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: lightColorScheme.primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: lightColorScheme.onSurfaceVariant,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.lg.value,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.modal,
          side: BorderSide(
            color: lightColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
        titleTextStyle: lightTextTheme.titleLarge?.copyWith(
          color: lightColorScheme.onSurface,
        ),
        contentTextStyle: lightTextTheme.bodyMedium?.copyWith(
          color: lightColorScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.xxl.value,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.bottomSheet,
          side: BorderSide(
            color: lightColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
        showDragHandle: true,
        dragHandleColor: lightColorScheme.onSurfaceVariant,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: lightColorScheme.onSurfaceVariant,
        textColor: lightColorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: Radii.button),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_sm,
        ),
        minVerticalPadding: Spacing.listItemVerticalPadding,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: lightColorScheme.inverseSurface,
          borderRadius: Radii.radiusSm,
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: lightColorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_2xs,
          vertical: Spacing.space_3xs,
        ),
        waitDuration: AppDurations.normal,
        showDuration: AppDurations.slower,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.tint(lightColorScheme.primary, 0.3),
        cursorColor: lightColorScheme.primary,
        selectionHandleColor: lightColorScheme.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightColorScheme.surface,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: lightColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppElevation.none.value,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: AppElevation.lg.value,
        shape: RoundedRectangleBorder(borderRadius: Radii.fab),
      ),
      // The router applies its own slide transition via CustomTransitionPage,
      // so this stays a plain fade to avoid double-animating routes.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Dark theme built with Material 3 and the project ColorScheme and TextTheme.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const [AppTextColors.dark],
      colorScheme: darkColorScheme,
      textTheme: darkTextTheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      hoverColor: AppColors.tint(darkColorScheme.primary),
      focusColor: AppColors.tint(darkColorScheme.primary, 0.12),
      appBarTheme: AppBarTheme(
        // D1: flat surface + hairline, matching the light theme.
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: AppElevation.none.value,
        scrolledUnderElevation: AppElevation.none.value,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        // D4: the theme's headlineMedium is the canonical app bar title style.
        titleTextStyle: darkTextTheme.headlineMedium,
        shape: Border(
          bottom: BorderSide(
            color: darkColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkColorScheme.surface,
        elevation: AppElevation.sm.value,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.card,
          side: BorderSide(
            color: darkColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          disabledBackgroundColor: darkColorScheme.surfaceContainerHigh,
          disabledForegroundColor: AppColors.inkFor(
            darkColorScheme.surfaceContainerHigh,
          ).withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // D5: violet ink + border; magenta is reserved for decorative fills.
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(
            color: darkColorScheme.primary,
            width: Radii.outlineWidth,
          ),
          disabledBackgroundColor: darkColorScheme.surfaceContainerHigh,
          disabledForegroundColor: AppColors.inkFor(
            darkColorScheme.surfaceContainerHigh,
          ).withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.space_md,
            vertical: Spacing.space_sm,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          disabledForegroundColor: AppColors.inkFor(
            darkColorScheme.surfaceContainerHigh,
          ).withValues(alpha: 0.38),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium.copyWith(
          color: darkColorScheme.onSurface,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.space_xs,
          vertical: Spacing.space_4xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.chip),
        selectedColor: AppColors.primaryLight,
        backgroundColor: Colors.transparent,
        checkmarkColor: darkColorScheme.onPrimary,
        secondarySelectedColor: AppColors.primaryLight,
        side: BorderSide(color: Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: darkColorScheme.primary,
        linearTrackColor: darkColorScheme.surfaceContainerHighest,
        circularTrackColor: darkColorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: darkColorScheme.onInverseSurface,
        ),
        actionTextColor: darkColorScheme.inversePrimary,
        disabledActionTextColor: darkColorScheme.onInverseSurface.withValues(
          alpha: 0.5,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: Radii.button),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: AppColors.textPrimaryDark),
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(color: darkColorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_md,
          vertical: Spacing.space_sm,
        ),
      ),
      iconTheme: IconThemeData(color: darkColorScheme.onSurfaceVariant),
      dividerTheme: DividerThemeData(
        color: darkColorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? darkColorScheme.primary
              : darkColorScheme.surfaceContainerHighest,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        // L16: the bottom nav surface is owned by the theme.
        backgroundColor: darkColorScheme.surface,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: darkColorScheme.primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: darkColorScheme.onSurfaceVariant,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.lg.value,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.modal,
          side: BorderSide(
            color: darkColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
        titleTextStyle: darkTextTheme.titleLarge?.copyWith(
          color: darkColorScheme.onSurface,
        ),
        contentTextStyle: darkTextTheme.bodyMedium?.copyWith(
          color: darkColorScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.xxl.value,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.bottomSheet,
          side: BorderSide(
            color: darkColorScheme.outline,
            width: Radii.outlineWidth,
          ),
        ),
        showDragHandle: true,
        dragHandleColor: darkColorScheme.onSurfaceVariant,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: darkColorScheme.onSurfaceVariant,
        textColor: darkColorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: Radii.button),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_sm,
        ),
        minVerticalPadding: Spacing.listItemVerticalPadding,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: darkColorScheme.inverseSurface,
          borderRadius: Radii.radiusSm,
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: darkColorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.space_2xs,
          vertical: Spacing.space_3xs,
        ),
        waitDuration: AppDurations.normal,
        showDuration: AppDurations.slower,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.tint(darkColorScheme.primary, 0.3),
        cursorColor: darkColorScheme.primary,
        selectionHandleColor: darkColorScheme.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkColorScheme.surface,
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: darkColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppElevation.none.value,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: AppElevation.lg.value,
        shape: RoundedRectangleBorder(borderRadius: Radii.fab),
      ),
      // The router applies its own slide transition via CustomTransitionPage,
      // so this stays a plain fade to avoid double-animating routes.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

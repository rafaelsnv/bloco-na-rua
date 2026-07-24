# Task Context: Widget Native Migration

Session ID: 2026-07-11-widget-native-migration
Created: 2026-07-11T00:00:00
Status: completed

Completed: 2026-07-11T00:00:00

## Current Request
Refactor 5 from-scratch widgets and 4 minor cleanups in `lib/ui/core/widgets/` to use Flutter's native Material widgets instead of manual Container/GestureDetector/BoxDecoration stacks, while preserving the same public API.

## Context Files (Standards to Follow)
- (No .opencode/context/ directory found in this repo; design system tokens in lib/ui/core/tokens/ are the source of truth)
- lib/ui/core/theme/app_theme.dart — existing ThemeData definitions
- lib/ui/core/tokens/app_radius.dart — Radii tokens
- lib/ui/core/tokens/app_duration.dart — AppDurations/AppCurves tokens
- lib/ui/core/tokens/app_typography.dart — AppTypography tokens
- lib/ui/core/tokens/app_colors.dart — AppColors tokens

## Reference Files (Source Material)
All widget files under lib/ui/core/widgets/:
- lib/ui/core/widgets/buttons/app_button.dart
- lib/ui/core/widgets/buttons/app_icon_button.dart
- lib/ui/core/widgets/buttons/app_fab.dart
- lib/ui/core/widgets/cards/app_card.dart, app_list_tile.dart, block_card.dart, meeting_card.dart, member_card.dart
- lib/ui/core/widgets/display/app_avatar.dart, app_badge.dart, app_chip.dart, app_section_header.dart, presence_chip.dart
- lib/ui/core/widgets/feedback/app_dialog.dart, app_loading_indicator.dart, app_snackbar.dart
- lib/ui/core/widgets/inputs/app_dropdown.dart, app_search_field.dart, app_text_field.dart
- lib/ui/core/widgets/navigation/app_app_bar.dart, app_bottom_nav.dart, app_shell.dart
- lib/ui/core/widgets/state/app_empty.dart, app_error.dart, app_loading.dart

## External Docs Fetched
None required — all target widgets (FilledButton, IconButton, Chip, CircleAvatar, AlertDialog, TweenAnimationBuilder) are stock Flutter.

## Components (8 Batches)
Batch 1: Theme additions (chipTheme, progressIndicatorTheme, snackBarTheme) in app_theme.dart
Batch 2: AppButton — replace Container+GestureDetector with FilledButton/OutlinedButton/TextButton
Batch 3: AppIconButton — replace with IconButton
Batch 4: AppChip + PresenceChip — replace with RawChip/ActionChip/InputChip
Batch 5: AppAvatar — replace with CircleAvatar for circle shape
Batch 6: AppDialog — replace with AlertDialog
Batch 7: AppLoadingIndicator.pulse — replace AnimationController with TweenAnimationBuilder
Batch 8: AppEmpty + AppError — replace raw FilledButton.icon with AppButton

## Constraints
- SDK: Flutter 3.8.1 (use Flutter 3.x native widgets)
- Public API must not change (AppButton.variant, AppChip.variant, etc.)
- Animations must respect MediaQuery.disableAnimationsOf(context)
- Tokens from lib/ui/core/tokens/ must be used (no hardcoded values)
- No new packages required
- No existing widget tests to update (none exist)

## Exit Criteria
- [x] AppButton uses FilledButton/OutlinedButton/TextButton (public API unchanged)
- [x] AppIconButton uses IconButton (public API unchanged)
- [x] AppChip uses RawChip/ActionChip/InputChip (public API unchanged)
- [x] AppAvatar uses CircleAvatar for circle shape (public API unchanged)
- [x] AppDialog uses AlertDialog (public API unchanged)
- [x] AppLoadingIndicator.pulse uses TweenAnimationBuilder (no AnimationController)
- [x] AppEmpty and AppError use AppButton for CTA
- [x] app_theme.dart has chipTheme, progressIndicatorTheme, snackBarTheme
- [x] All widgets compile without errors (flutter analyze passes)
- [x] No new packages added to pubspec.yaml

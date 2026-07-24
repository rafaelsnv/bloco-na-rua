# Guide: Theme Mockup Alignment

**What**: Flutter implementation corrected to match HTML mockup spec at `.tmp/design-plans/color-palette-mockup.html`. Token values already correct; component-level fixes applied.

**Status**: ✅ Complete — 9 mismatches fixed, dart analyze passes zero issues.

---

## 9 Fixes Applied

| # | Component | Fix |
|---|----------|-----|
| 1 | AppBar light | bg = `AppColors.primary` (violet), fg = white |
| 2 | Card light+dark | 1px `outline` border added |
| 3 | Input radius | 8px → 12px (`radiusMd`) |
| 4a | AppButton | Added `accent` variant (orange, white bold, 12px, shadow) |
| 4b | AppButton | `case AppButtonVariant.accent: return Colors.white` |
| 5 | AppDialog | Uses `AppButton.accent` instead of raw `FilledButton` |
| 6 | AppChip | Brightness-aware; soft opacity 15% → 20% |
| 7 | BottomNav | indicator transparent; active = `AppColors.primary` |

---

## Files Modified

- `lib/ui/core/theme/app_theme.dart` — AppBar light + Card border
- `lib/ui/core/widgets/buttons/app_button.dart` — accent variant
- `lib/ui/core/widgets/display/app_chip.dart` — brightness + opacity
- `lib/ui/core/tokens/app_radius.dart` — input 12px
- `lib/ui/core/widgets/navigation/app_bottom_nav.dart` — nav active color
- `lib/ui/core/widgets/feedback/app_dialog.dart` — dialog buttons

**Not modified**: `app_colors.dart`, `app_color_schemes.dart`, `app_typography.dart`

---

## Verification

```bash
dart analyze lib/ui/    # → No issues found ✅
dart analyze test/      # → No issues found ✅
```

**Reference**: `.tmp/design-plans/theme-mockup-alignment.md`

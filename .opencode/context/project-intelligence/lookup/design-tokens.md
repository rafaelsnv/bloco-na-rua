<!-- Context: project-intelligence/lookup/design-tokens | Priority: high | Version: 1.0 | Updated: 2026-11-17 -->

# Design Tokens Lookup - "Fireworks on Velvet"

**Core Concept**: Design system "Fireworks on Velvet" (Violet #7C3AED primary, pt-BR UI). Each token type has exactly ONE source of truth file — never introduce a second scale or inline literal.

---

## Token Map

| Token | Location | Notes |
|-------|----------|-------|
| `AppColors` | `lib/ui/core/tokens/app_colors.dart` | ONLY place with `Color(0x` literals |
| `AppColors.inkFor(fill)` | `app_colors.dart` | Unique luminance rule, threshold `0.4` (`inkLuminanceThreshold`) |
| `AppElevation` | `lib/ui/core/tokens/app_elevation.dart` | Scale: none/sm/md/lg/xl/xxl |
| `Spacing` + `AppIconSizes` | `lib/ui/core/tokens/app_spacing.dart` | BOTH live in one file; sizes 14/16/20/24/28/32/40/44/48 |
| `Radii` | `lib/ui/core/tokens/app_radius.dart` | `outlineWidth` = 1.5 |
| Typography | `lib/ui/core/tokens/app_typography.dart` | Sora + DM Sans |
| `AppTextColors` | `lib/ui/core/theme/app_text_colors.dart` | Extension |

> ⚠️ There is NO `app_icon_sizes.dart` file — `AppIconSizes` lives inside `app_spacing.dart`.

---

## Invariants (do NOT undo)

- `AppElevation` is the only elevation scale (no `AppCardElevation`, no inline `Colors.white` shadows)
- `AppColors.inkFor` (threshold 0.4) is the only luminance rule; `computeLuminance` only in `app_colors.dart`
- `Radii.outlineWidth = 1.5`
- `AppIconTile` is the only icon-tile widget
- `AppStateView` backs `AppEmpty`/`AppError`; `AppSpinner` backs all spinners
- Accent variant ink = `AppColors.textPrimary` in both modes
- Disabled filled-button ink derived from its fill via `inkFor` (fixed a real 2.0:1 failure)
- `Color(0x` literals only in `app_colors.dart`
- No relative imports (`import '..`) anywhere in `lib/ui/`
- No raw `AlertDialog(`/`showDialog(`/`SnackBar(` outside core widgets

---

## Reference

- Verified facts and pending findings: `CONTINUE.md` sections 5-6
- Architecture context: `../concepts/architecture.md`

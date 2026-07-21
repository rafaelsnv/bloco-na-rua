<!-- Context: project-intelligence/lookup/token-discipline | Priority: high | Version: 1.0 | Updated: 2026-07-08 -->

# Token Discipline — Zero Hardcoded Values

**Core Concept**: `lib/ui/` contains **zero** hardcoded colors, spacings, radii, durations, curves, font sizes, or font weights outside the token layer. Every primitive + screen uses `AppColors`, `Spacing`, `Radii`, `AppDurations`, `AppCurves`, `AppTypography`. Established during design-system migration (Phases 0–5c, completed 2026-07-08).

> Source of truth: `.tmp/.archive/2026-07-08/sessions/2026-07-03-design-system/HANDOFF.md §5` and `2026-07-08-design-system-extended/HANDOFF.md §5`.

---

## Forbidden Patterns (in `lib/ui/`)

| ❌ Forbidden                                  | ✅ Use instead                                |
|----------------------------------------------|----------------------------------------------|
| `Colors.X.Y` (any named color)               | `AppColors.primary`, `AppColors.surface`, etc. |
| `Color(0xFF...)` outside avatar palette      | `AppColors.*` (token) — see exceptions below |
| `EdgeInsets.all(N)` / `EdgeInsets.symmetric(h: N, v: N)` (literal `N`) | `EdgeInsets.all(Spacing.space_sm)`, etc. |
| `BorderRadius.circular(N)` / `Radius.circular(N)` (literal `N`) | `Radii.card`, `Radii.modal`, etc. |
| `Duration(milliseconds: N)`                  | `AppDurations.fast`, `AppDurations.normal`, etc. |
| `Curves.easeOutCubic`, `Curves.easeInOut`    | `AppCurves.standard`, `AppCurves.emphasized`, etc. |
| `fontSize: N`                                | `AppTypography.titleMedium` (or another token getter) |
| `FontWeight.bold`, `FontWeight.w500`         | `AppTypography.x.fontWeight` (token-driven) |
| Single-quoted strings inside `Text(...)`     | Double quotes — `"text"` not `'text'`        |

---

## Acceptable Exceptions (documented)

| Where                                                            | Why                                                                                          |
|------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| `lib/ui/core/widgets/display/app_avatar.dart`                    | Inline `Color(0xFF8B5CF6)` (purple) + `Color(0xFFEC4899)` (pink) for the 6-color avatar palette. Mark with `// AVATAR_PALETTE` comment. |
| `lib/ui/core/theme/app_color_schemes.dart`                       | `Color(0xFF...)` for derived Material 3 shades (seed-color derived tones)                    |
| `AppSnackbar`, `AppChip` (avatar icons), `AppAvatar` (initials), `AppLoadingIndicator` | `Colors.white` for semantic foreground on colored backgrounds                                |
| `Colors.transparent`                                             | For hiding tints (e.g., `Colors.transparent` in `IconButton` splash)                         |
| Inside `app_typography.dart`                                     | Inline `fontSize` / `FontWeight` definitions ARE the source — they're tokenized by being here |
| Inside `app_button.dart`, `app_snackbar.dart`                    | After migration, tokenized values are used (the `fontSize` was extracted to `buttonSmall/Medium/Large` getters) |

---

## Token Quick Reference

| File                            | Class           | Purpose                                                  |
|---------------------------------|-----------------|----------------------------------------------------------|
| `lib/ui/core/tokens/app_colors.dart`   | `AppColors`    | 24 `static const Color`                                  |
| `lib/ui/core/tokens/app_spacing.dart`  | `Spacing`      | 16 `static const double` (uses `// ignore_for_file: constant_identifier_names` for `space_4xs` etc.) |
| `lib/ui/core/tokens/app_radius.dart`   | `Radii`        | 7 numeric + 6 generic `BorderRadius` + 8 component `BorderRadius` (named `Radii`, NOT `AppRadius`, to avoid conflict with Flutter's `Radius`) |
| `lib/ui/core/tokens/app_duration.dart` | `AppDurations` + `AppCurves` | 5 durations + 4 curves                       |
| `lib/ui/core/tokens/app_typography.dart` | `AppTypography` | 15 original + 3 button-size getters (Fredoka + Nunito) |

---

## Verification Greps

Run these before any PR that touches `lib/ui/`. Expected: zero matches in `lib/ui/` (excluding `core/tokens/`).

```bash
# Named colors (catch Colors.X.Y usage)
grep -rnE "Colors\.(black|red|green|blue|yellow|orange|purple|pink|grey|amber|cyan|teal|indigo|lime|brown|deepOrange|deepPurple|blueGrey)" lib/ui/ | grep -v "core/tokens/"

# Hardcoded spacing / radius / font sizes
grep -rnE "EdgeInsets\.all\([0-9]+\)|BorderRadius\.circular\([0-9]+\)|fontSize: [0-9]+|fontWeight: FontWeight\." lib/ui/ | grep -v "core/tokens/"

# Legacy imports (should be zero post-Phase 5c)
grep -rE "ui/core/colors/|ui/core/widgets/(avatar_member|badge_widget|card_button|chip_date|copy_code_card|empty_state_widget|error_snackbar|error_state_widget|offline_banner|profile_button|section_header|server_error_card)|ui/core/theme/(bloco_na_rua_theme|light_theme|dark_theme)" lib/

# Single-quoted strings (catch quoting style violations)
grep -rnE "Text\('[a-zA-Z]" lib/ui/
```

---

## Reference

- `lookup/widgets-api.md` — which primitives use which tokens
- `lookup/naming-conventions.md` — file/folder/class naming
- `design-system/bloco-na-rua/MASTER.md` — source palette + spacing scale
- `.tmp/.archive/2026-07-08/sessions/2026-07-03-design-system/HANDOFF.md` §5 — final token discipline audit
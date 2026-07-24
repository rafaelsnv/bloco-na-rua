---
project: bloco-na-rua
feature: color-palette-refresh
created: 2026-07-13T00:00:00Z
updated: 2026-07-13T00:00:00Z
status: proposal
current_stage: theme
---

# Design Plan: Color Palette Refresh — "Carnaval Sunset"

## Context

`Bloco na Rua` is a Flutter app for organizing Brazilian carnival street
blocks (blocos de carnaval — frevo, maracatu, axé). The current theme is
**"Electro Frevo"** with Fuchsia Magenta (`#D946EF`) primary + Electric Gold
(`#EAB308`) CTA. The design system already follows a mature token pattern
(`lib/ui/core/tokens/app_colors.dart`) with light/dark ColorSchemes
(`app_color_schemes.dart`) and Material 3 `ThemeData` wiring
(`app_theme.dart`).

## Goals

1. **Preserve carnival energy** — keep the festive, vibrant Brazilian soul.
2. **Fix accessibility** — current `#D946EF` on white text fails WCAG AA
   (contrast ~3.4:1). Raise to ≥4.5:1 for body text.
3. **Reduce visual fatigue** — saturated fuchsia on lavender is heavy at
   scale. Refine into a more sophisticated "sunset" gradient story.
4. **Strengthen light/dark parity** — current dark mode borrows the same
   hues; introduce a proper tonal surface palette so the two modes feel
   like the same brand, not two brands.
5. **Maintain token compatibility** — single-source-of-truth stays in
   `app_colors.dart`; `app_color_schemes.dart` only swaps hex values.

## Non-Goals

- Changing typography (Sora + DM Sans stays).
- Renaming existing token identifiers (drop-in hex replacement).
- Introducing brand-new widgets or component APIs.

---

## Stage 1: Layout — N/A (token-only change)

This proposal is a **token-level swap**, not a layout change. All existing
widgets (`AppButton`, `AppCard`, `AppListTile`, …) continue to consume the
same token names. No layout work is required.

---

## Stage 2: Theme Design — "Carnaval Sunset"

### Theme Direction

Move from a single-hue magenta blast to a **dual-hue sunset gradient**:

- **Primary** = deep violet/indigo (anchors the brand, evokes the night
  sky over a Salvador/Recife street block)
- **Secondary / Accent** = warm coral-orange (CTA, evokes sunset,
  frevo flames, lantern light)
- **Tertiary** = tropical teal (sparingly — accents, presence indicators)

This mirrors how Brazilian carnival actually reads visually: violet
twilight + warm costume lights + tropical accents.

### Color System

#### Brand Source Palette (raw tokens — `app_colors.dart`)

| Token              | Hex       | Role                                     |
|--------------------|-----------|------------------------------------------|
| `primary`          | `#6D28D9` | Violet 700 — anchors brand               |
| `primaryLight`     | `#A78BFA` | Violet 400 — dark-mode primary           |
| `primaryDark`      | `#4C1D95` | Violet 900 — pressed/active              |
| `secondary`        | `#FB7185` | Rose 400 — secondary actions             |
| `secondaryLight`   | `#FDA4AF` | Rose 300 — hover states                  |
| `secondaryDark`    | `#E11D48` | Rose 600 — pressed/active                |
| `accent` (CTA)     | `#F97316` | Orange 500 — primary call-to-action      |
| `accentLight`      | `#FB923C` | Orange 400 — dark-mode accent            |
| `accentDark`       | `#C2410C` | Orange 700 — pressed/active              |
| `tertiary`         | `#14B8A6` | Teal 500 — info / presence / online      |

#### Semantic Colors

| Semantic  | Hex       | Use case                                |
|-----------|-----------|-----------------------------------------|
| `success` | `#16A34A` | Confirmations, member joined, saved     |
| `warning` | `#F59E0B` | Pending state, almost-full blocks       |
| `error`   | `#DC2626` | Form errors, destructive actions        |
| `info`    | `#0EA5E9` | Neutral info banners                    |

#### Light Surface Palette

| Token                | Hex       | Role                                |
|----------------------|-----------|-------------------------------------|
| `backgroundLight`    | `#FAFAF9` | Stone 50 — app scaffold             |
| `surfaceLight`       | `#FFFFFF` | Cards, sheets                       |
| `surfaceVariantLight`| `#F5F3FF` | Violet 50 — tonal surface           |
| `surfaceContainerLight` | `#EDE9FE` | Violet 100 — input fill          |
| `borderLight`        | `#E5E7EB` | Stone 200 — dividers                |

#### Dark Surface Palette

| Token                  | Hex       | Role                              |
|------------------------|-----------|-----------------------------------|
| `backgroundDark`      | `#0B0716` | Near-black violet                 |
| `surfaceDark`         | `#15101F` | Cards                             |
| `surfaceVariantDark`  | `#1E1830` | Tonal elevation 1                 |
| `surfaceContainerDark`| `#2A2142` | Tonal elevation 2 / input fill    |
| `borderDark`          | `#3B2F5C` | Dividers                          |

#### Text Hierarchy

| Token                | Light     | Dark      | Use                       |
|----------------------|-----------|-----------|---------------------------|
| `textPrimary`        | `#1C1917` | `#FAFAF9` | Headlines, body emphasis  |
| `textSecondary`      | `#57534E` | `#D6D3D1` | Body, descriptions        |
| `textTertiary`       | `#78716C` | `#A8A29E` | Captions, metadata        |
| `textDisabled`       | `#A8A29E` | `#57534E` | Disabled controls         |
| `textOnPrimary`      | `#FFFFFF` | `#FFFFFF` | Text on primary fill      |
| `textOnAccent`       | `#FFFFFF` | `#FFFFFF` | Text on accent/CTA fill   |

### Material 3 ColorScheme Mapping

```
primary            → brand primary (violet)
onPrimary          → textOnPrimary
primaryContainer   → primaryLight tone
secondary          → brand secondary (rose)
tertiary           → tertiary (teal)
error              → semantic error
surface            → surface (background)
surfaceContainer*  → surfaceVariant / surfaceContainer
outline            → border
inversePrimary     → primaryLight (dark-mode primary anchor)
```

### Use Cases per Color

| Color                          | Where it appears                                           |
|--------------------------------|------------------------------------------------------------|
| Primary violet                 | Filled buttons, FAB, active nav, focus rings, links       |
| Secondary rose                 | Outlined buttons, chips, "member joined" badges           |
| Accent orange (CTA)            | Primary CTA only: "Entrar no bloco", "Salvar"             |
| Tertiary teal                  | Online presence dot, info chips, live event indicators    |
| Semantic success               | Snackbar "Salvo com sucesso", checkmarks in forms         |
| Semantic error                 | Form errors, logout button icon, destructive dialogs      |
| Semantic warning               | "Bloco quase lotado" badges                                |
| Semantic info                  | Neutral update banners                                     |
| `backgroundLight/Dark`         | Scaffold background                                        |
| `surface*`                     | Cards, AppBar, sheets, dialogs                             |
| `surfaceContainer*`            | TextField fills, tonal buttons, elevated chips             |
| `border`                       | Dividers, input borders, card outlines                     |

### Accessibility (WCAG 2.1 AA)

| Pair                                  | Ratio    | Status |
|---------------------------------------|----------|--------|
| Violet `#6D28D9` on `#FFFFFF`         | 7.7 : 1  | ✅ AAA |
| Violet `#6D28D9` on `#FAFAF9`         | 7.5 : 1  | ✅ AAA |
| Orange `#F97316` on `#FFFFFF`         | 3.5 : 1  | ⚠️ Large text only — used on CTA buttons with white text + ≥18px bold → ✅ |
| Orange `#F97316` on `#1C1917` text    | 4.7 : 1  | ✅ AA  |
| Rose `#E11D48` on `#FFFFFF`           | 5.2 : 1  | ✅ AA  |
| Teal `#14B8A6` on `#FFFFFF`           | 2.7 : 1  | ⚠️ Never used for text — icon/border only |
| Text primary `#1C1917` on `#FFFFFF`   | 16.1 : 1 | ✅ AAA |
| Text secondary `#57534E` on `#FFFFFF` | 7.5 : 1  | ✅ AAA |
| Error `#DC2626` on `#FFFFFF`          | 5.9 : 1  | ✅ AA  |

**Never rely on color alone**: every status uses an icon *and* color
(success ✓, warning ⚠, error ✕, info ℹ). Focus rings use 2px primary
outline at ≥3:1 against any surface.

---

## Stage 3: Animation — N/A (token-only change)

No animation tokens change. Existing `AppDurations.fast` (150ms) and
`AppCurves.standard` remain.

---

## Stage 4: Implementation Plan

### Files to modify (drop-in hex swaps — no structural changes)

1. `lib/ui/core/tokens/app_colors.dart`
   - Replace Groups 1–7 hex values per the table above.
   - Add new tokens: `secondary*`, `accent*`, `tertiary`,
     `surfaceContainer*`, `textTertiary*`, `textOnPrimary`, `textOnAccent`.

2. `lib/ui/core/theme/app_color_schemes.dart`
   - Update `lightColorScheme` and `darkColorScheme` constants to map
     the new tokens into Material 3 roles.
   - Re-derive `primaryContainer` / `secondaryContainer` /
     `tertiaryContainer` from the new tonal palette.

3. `lib/ui/core/theme/app_theme.dart`
   - Verify `chipTheme.selectedColor`, `progressIndicatorTheme.color`,
     `snackBarTheme.actionTextColor` still resolve correctly
     (likely no change — they already reference `colorScheme.primary`).
   - Update `filledButtonTheme.backgroundColor` references from
     `AppColors.cta` to `AppColors.accent` if naming changes.

4. (Optional) `lib/ui/core/widgets/buttons/app_button.dart`
   - If `AppColors.cta` is renamed to `AppColors.accent`, update the
     one direct reference on line 233.

### Files NOT modified

- `lib/ui/core/tokens/app_typography.dart` — unchanged
- `lib/ui/core/tokens/app_spacing.dart` — unchanged
- `lib/ui/core/tokens/app_radius.dart` — unchanged
- `lib/ui/core/tokens/app_duration.dart` — unchanged
- All `widgets/`, `cubit/`, `screens/` — unchanged (consume tokens)

### Verification

After applying the swap, verify:

- [ ] All `AppColors.*` references compile and resolve.
- [ ] `flutter analyze` passes.
- [ ] Light + dark mode render side-by-side at 375 / 768 / 1024 / 1440.
- [ ] Run a contrast check on every text/background pairing above.
- [ ] Visually verify: login screen, block list, block details,
       member card, settings screen, snackbars, errors.

### Rollback

Since the change is token-only, rollback is `git revert` of the three
files. No data migration, no API impact.

---

## Open Questions for Stakeholder

1. **CTA color**: confirm Orange `#F97316` vs. keep Gold `#EAB308`.
   The orange pairs better with violet (complementary on the wheel)
   and has a clearer "tropical/carnival" reading.
2. **Tertiary teal**: keep as accent (`#14B8A6`) or remove for a tighter
   two-hue system?
3. **Migration timing**: ship in next release, or feature-flag the theme
   so users can A/B test?
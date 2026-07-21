# Design System Analysis — Final Report

## Bloco na Rua | Carnaval Sunset Theme

---

## 1. Executive Summary

**What was done:**
A comprehensive audit of the Bloco na Rua design system covering color, typography, spacing, border radius, and component patterns. The analysis identified accessibility gaps, naming collisions, and inconsistencies, then produced a phased proposal to refine the system while maintaining backward compatibility.

**Key findings:**
- **Critical:** Secondary color `#FB7185` fails WCAG AA contrast (2.8:1 on white)
- **Good foundation:** 4px spacing grid, semantic radius tokens, clear font separation (Sora/DM Sans)
- **Minor inconsistencies:** Accent button radius mismatch, hardcoded button padding, chip doc/code drift, card border width discrepancy
- **Proposal:** 5-phase implementation plan prioritizing accessibility fixes, typography cleanup, and new motion/elevation tokens

---

## 2. Current Design System Overview

### 2.1 Architecture

```
lib/ui/core/
├── theme/      → AppTheme.light() / AppTheme.dark()
├── tokens/     → app_colors.dart, app_typography.dart, app_spacing.dart, app_radius.dart
└── widgets/    → buttons/, cards/, inputs/, ...
```

### 2.2 Color System — Carnaval Sunset

| Group     | Token                      | Light                                 | Dark                  |
| --------- | -------------------------- | ------------------------------------- | --------------------- |
| Primary   | `primary`                    | `#6D28D9` (violet)                      | `#A78BFA`               |
| Secondary | `secondary`                  | `#FB7185` (rose)                        | —                     |
| Accent    | `accent`                     | `#F97316` (orange)                      | —                     |
| Tertiary  | `tertiary`                   | `#14B8A6` (teal)                        | —                     |
| Semantic  | success/warning/error/info | `#16A34A` / `#F59E0B` / `#DC2626` / `#0EA5E9` | —                     |
| Surface   | `background`                 | `#FAFAF9` (stone)                       | `#0B0716` (deep violet) |
| Surface   | `surface`                    | `#FFFFFF`                               | `#15101F`               |
| Text      | `textPrimary`                | `#1C1917`                               | `#FAFAF9`               |
| Text      | `textSecondary`              | `#57534E`                               | `#D6D3D1`               |

### 2.3 Typography

| Role          | Family  | Size | Weight |
| ------------- | ------- | ---- | ------ |
| `displayLarge`  | Sora    | 57px | 700    |
| `headlineLarge` | Sora    | 32px | 600    |
| `titleLarge`    | DM Sans | 22px | 600    |
| `titleMedium`   | DM Sans | 16px | 600    |
| `titleSmall`    | DM Sans | 14px | 500    |
| `bodyLarge`     | DM Sans | 16px | 400    |
| `labelLarge`    | DM Sans | 14px | 500    |
| `buttonMedium`  | DM Sans | 16px | 600    |

### 2.4 Spacing (4px Grid)

| Token     | Value |
| --------- | ----- |
| `space_4xs` | 2px   |
| `space_3xs` | 4px   |
| `space_2xs` | 8px   |
| `space_xs`  | 12px  |
| `space_sm`  | 16px  |
| `space_md`  | 24px  |
| `space_lg`  | 32px  |
| `space_xl`  | 48px  |
| `space_2xl` | 64px  |
| `space_3xl` | 80px  |

### 2.5 Border Radius

| Token | Value  | Assigned To            |
| ----- | ------ | ---------------------- |
| `none`  | 0px    | —                      |
| `xs`    | 4px    | —                      |
| `sm`    | 8px    | button                 |
| `md`    | 12px   | card, input            |
| `lg`    | 16px   | fab, chip, modal       |
| `xl`    | 24px   | bottomSheet (top only) |
| `full`  | 9999px | avatar                 |

### 2.6 Strengths

- ✓ **Well-structured spacing grid** — consistent 4px base unit throughout
- ✓ **Clear font family separation** — Sora for display/headlines, DM Sans for body/UI
- ✓ **Semantic radius tokens** — pre-built `BorderRadius` instances mapped to components
- ✓ **Dark mode primary inversion** — `primary` becomes `primaryLight` for contrast
- ✓ **Light mode surface palette** — warm stone anchor with violet tonal ladder
- ✓ **Component tokenization** — buttons, cards, inputs derive from design tokens
- ✓ **No bundled font assets** — google_fonts keeps APK lean
- ✓ **Low severity issues overall** — no critical architectural flaws

---

## 3. Key Issues Identified

### 3.1 Accessibility Issues (Priority: Critical)

| #   | Issue                      | Current        | WCAG                 | Fix                       |
| --- | -------------------------- | -------------- | -------------------- | ------------------------- |
| A1  | **Secondary `#FB7185` contrast** | 2.8:1 on white | AA requires 4.5:1    | Change to `#BE123C`         |
| A2  | **Accent `#F97316` contrast**    | 3.2:1 on white | AA passes, AAA fails | Change to `#EA580C`         |
| A3  | **Text secondary `#57534E`**     | 5.2:1          | AAA fails for body   | Reserve for captions only |

### 3.2 Typography Issues (Priority: Medium)

| #   | Issue                                                                          | Location            |
| --- | ------------------------------------------------------------------------------ | ------------------- |
| T1  | `titleSmall` (14px, w500) ≈ `labelLarge` (14px, w500) — functionally identical     | app_typography.dart |
| T2  | Button styles collide with text roles — `buttonMedium` = `bodyLarge` (diff weight) | app_typography.dart |
| T3  | Line-height ratios drift 1.12→1.33 without 4px baseline grid rule              | app_typography.dart |

### 3.3 Component & Spacing Issues (Priority: Low–Medium)

| #   | Issue                                                  | Location              | Severity |
| --- | ------------------------------------------------------ | --------------------- | -------- |
| C1  | Accent button radius mismatch (12px vs 8px for others) | app_button.dart:258   | Medium   |
| C2  | `lg` button vertical padding hardcoded `20.0`              | app_button.dart:101   | Low      |
| C3  | Chip doc says "pill/full" but uses `Radii.lg` (16px)     | app_radius.dart:71-72 | Low      |
| C4  | Card border 1.5px vs theme card 1px                    | app_card.dart:84      | Low      |
| C5  | Accent button elevation un-tokenized (6dp/0dp by mode) | app_button.dart:256   | Low      |

### 3.4 Dark Mode Surface Issues

| #   | Issue                                                                 | Severity |
| --- | --------------------------------------------------------------------- | -------- |
| D1  | Missing `surfaceContainerHigh` and `surfaceContainerHighest` in dark mode | Medium   |

---

## 4. Proposed Improvements Summary

### 4.1 Colors (Phase 1 — Critical)

| Role      | Current | Proposed | Contrast Change |
| --------- | ------- | -------- | --------------- |
| `secondary` | `#FB7185` | `#BE123C`  | 2.8:1 → 6.1:1 ✓ |
| `tertiary`  | `#14B8A6` | `#0F766E`  | 3.4:1 → 5.5:1 ✓ |
| `accent`    | `#F97316` | `#EA580C`  | 3.2:1 → 4.7:1 ✓ |

New surface ladder for dark mode with `surfaceContainerHigh` (#2A2436) and `surfaceContainerHighest` (#353043).

### 4.2 Typography (Phase 2 — High)

- `titleSmall` weight: 500→600 (differentiates from `labelLarge`)
- Deprecate `buttonSmall/Medium/Large` → use `labelLarge` with size variants
- Document 4px line-height baseline rule

### 4.3 Spacing (Phase 3 — Medium)

- Add `space_0` (0px) and `space_4xl` (96px)
- Add `buttonPaddingVLg` (16px) semantic token
- Add `outlineCard` (1.5px) semantic token

### 4.4 Radius (Phase 3 — Medium)

- Add `buttonPrimary` (sm=8px), `buttonAccent` (md=12px) semantic aliases
- Resolve chip radius: pill (full) vs rounded rectangle (lg) — recommend **pill**
- Align chip documentation with implementation

### 4.5 New Token Scales (Phase 4 — Low)

- `AppElevation` — 6 elevation levels (0–12dp) with shadow tokens
- `AppMotion` — Duration tokens (short/medium/long/slower) + easing curves

---

## 5. Implementation Phases

| Phase                   | Priority | Changes                                                                                                                                       | Issues Addressed |
| ----------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| **1 — Access & dark mode**  | Critical | (a) Bump secondary `#FB7185` → `#BE123C`, (b) tertiary `#14B8A6` → `#0F766E`, (c) accent `#F97316` → `#EA580C`, (d) add dark `surfaceContainerHigh/Highest` | A1, A2, D1       |
| **2 — Typography roles**    | High     | (a) `titleSmall` 500→600, (b) deprecate `buttonSmall/Medium/Large` → `labelLarge`, (c) document line-height baseline                                | T1, T2, T3       |
| **3 — Token harmonization** | Medium   | (a) `buttonPaddingVLg`, (b) `outlineCard`, (c) radius semantic aliases, (d) chip doc alignment                                                    | C1, C2, C3, C4   |
| **4 — New token scales**    | Low      | (a) `AppElevation`, (b) `AppMotion`, (c) wire components                                                                                          | C5               |
| **5 — Documentation**       | Low      | (a) Update radius doc, (b) contrast audit script, (c) refresh synthesis                                                                       | Hygiene          |

### Migration Strategy

**Additive only** — no token renames. Old tokens marked `@Deprecated` for one release cycle.

```
Phase 1 → Ship behind useRefinedColors2026 flag → toggle on for next release
Phase 2 → Find/replace button styles via rg
Phase 3 → Sweep components for new semantic tokens
Phase 4 → Add new token classes, update elevation mappings
Phase 5 → Remove deprecated getters, finalize docs
```

---

## 6. Files Changed/Created

### Files to Update

| File                                        | Changes                                                          |
| ------------------------------------------- | ---------------------------------------------------------------- |
| `lib/ui/core/tokens/app_colors.dart`          | Update hexes, add role pairs                                     |
| `lib/ui/core/tokens/app_typography.dart`      | Add `labelLarge` size variants, deprecate `buttonSmall/Medium/Large` |
| `lib/ui/core/tokens/app_spacing.dart`         | Add `space_0`, `space_4xl`, `buttonPaddingVLg`, `outlineCard`            |
| `lib/ui/core/tokens/app_radius.dart`          | Add `buttonPrimary`, `buttonAccent`, `chip` semantic aliases           |
| `lib/ui/core/theme/app_color_schemes.dart`    | New hexes for light/dark                                         |
| `lib/ui/core/theme/app_theme.dart`            | Wire new surface roles for dark mode                             |
| `lib/ui/core/widgets/buttons/app_button.dart` | Use tokens, drop hardcoded `20.0`                                  |
| `lib/ui/core/widgets/cards/app_card.dart`     | Use `outlineCard`, elevation tokens                                |

### Files to Create

| File                                  | Purpose                          |
| ------------------------------------- | -------------------------------- |
| `lib/ui/core/tokens/app_elevation.dart` | 6 elevation levels + `shadowFor()` |
| `lib/ui/core/tokens/app_motion.dart`    | Duration + easing tokens         |

### Documentation Files

| File                                                                | Purpose                       |
| ------------------------------------------------------------------- | ----------------------------- |
| `.tmp/tasks/design-system-analysis/REPORT.md`                         | This report                   |
| `.tmp/tasks/design-system-analysis/findings/05-colors.md`             | Color system analysis         |
| `.tmp/tasks/design-system-analysis/findings/06-typography.md`         | Typography system analysis    |
| `.tmp/tasks/design-system-analysis/findings/07-spacing-components.md` | Spacing & components analysis |
| `.tmp/tasks/design-system-analysis/findings/08-synthesis.md`          | Current system synthesis      |
| `.tmp/tasks/design-system-analysis/findings/09-proposal.md`           | Detailed improvement proposal |

---

## 7. Acceptance Criteria

- [ ] Contrast ratios for every color role on `surface` meet WCAG AA (4.5:1) or better
- [ ] No duplicate scale tokens (same size, weight, line-height, letter-spacing)
- [ ] Every component reads radius, padding, border, elevation from named tokens
- [ ] `AppElevation` exists in light + dark variants with documented shadow blends
- [ ] `AppMotion` exposes `short/medium/long/slower` and easing curves
- [ ] Migration phases 1–5 ship without renaming existing tokens (addative only)
- [ ] `flutter analyze` clean throughout

---

**Status:** Analysis complete. Proposal ready for review. System is production-ready once Phase 1 accessibility fixes are applied.

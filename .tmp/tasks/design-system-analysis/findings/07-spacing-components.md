# Spacing & Components Analysis

## 1. Spacing System (4px Grid)

**Tokens:**

| Token     | Value | Usage                                |
| --------- | ----- | ------------------------------------ |
| `space_4xs` | 2px   | Tight gaps                           |
| `space_3xs` | 4px   | Minimal spacing                      |
| `space_2xs` | 8px   | Icon gaps, small padding             |
| `space_xs`  | 12px  | Chip padding, small gaps             |
| `space_sm`  | 16px  | Standard padding, button horizontal  |
| `space_md`  | 24px  | Section spacing, page padding mobile |
| `space_lg`  | 32px  | Page padding desktop                 |
| `space_xl`  | 48px  | Large gaps                           |
| `space_2xl` | 64px  | XL spacing                           |
| `space_3xl` | 80px  | XXL spacing                          |

**Layout Combinations:**

- `pagePaddingMobile`: 16.0
- `pagePaddingTablet`: 24.0
- `pagePaddingDesktop`: 32.0
- `cardPadding`: 16.0
- `sectionGap`: 24.0
- `listItemVerticalPadding`: 12.0

**Status:** ✓ Well-structured, consistent 4px base unit.

---

## 2. Border Radius Tokens

**Base Tokens:**

| Token | Value  |
| ----- | ------ |
| `none`  | 0px    |
| `xs`    | 4px    |
| `sm`    | 8px    |
| `md`    | 12px   |
| `lg`    | 16px   |
| `xl`    | 24px   |
| `full`  | 9999px |

**Semantic Assignments:**

| Component   | Token | Value           |
| ----------- | ----- | --------------- |
| button      | `sm`    | 8px             |
| card        | `md`    | 12px            |
| input       | `md`    | 12px            |
| fab         | `lg`    | 16px            |
| chip        | `lg`    | 16px*          |
| modal       | `lg`    | 16px            |
| bottomSheet | `xl`    | 24px (top only) |
| avatar      | `full`  | 9999px          |

**Status:** ✓ Good semantic mapping, pre-built `BorderRadius` instances provided.

---

## 3. Component Style Patterns

### AppButton

- **Variants:** primary, secondary, accent, tertiary, ghost
- **Sizes:** sm (36h×8h×12v), md (44h×12h×16v), lg (52h×16h×20v)
- **Radius:** Uses `Radii.button` (sm=8px), except accent uses `Radii.radiusMd` (12px)
- **Typography:** Size-based tokens, accent overrides to `buttonLarge` + bold

### AppCard

- **Elevation:** none(0), xs(1), sm(2), md(4), lg(8) — maps to Material dp
- **Padding:** `Spacing.cardPadding` (16px)
- **Radius:** `Radii.card` (md=12px)
- **Border:** 1.5px outline from theme

### AppTextField

- **Wraps:** `TextFormField` for form validation
- **Decoration:** Delegates to `ThemeData.inputDecorationTheme`
- **Radius:** `Radii.input` (md=12px) via theme
- **Content padding:** `horizontal: space_md (24)`, `vertical: space_sm (16)`

---

## 4. Inconsistencies & Issues

| #   | Issue | Location | Severity |
| --- | ----- | -------- | -------- |
| 1   | **Accent button radius mismatch**: Accent uses `Radii.radiusMd` (12px) while other variants use `Radii.button` (8px). | `app_button.dart:258` | Medium |
| 2   | **Hardcoded vertical padding for lg**: `AppButtonSize.lg: 20.0` is hardcoded instead of using `Spacing.space_md` (24) or a named token. | `app_button.dart:101` | Low |
| 3   | **Chip radius doc/code mismatch**: Doc comment says "pill shape when height allows" with `full`, but actual code uses `Radii.lg` (16px). | `app_radius.dart:71-72` | Low |
| 4   | **Card border width (1.5px) vs theme card (1px)**: `AppCard` uses 1.5px outline while `CardThemeData` in `AppTheme` uses 1px. | `app_card.dart:84` | Low |
| 5   | **Accent button elevation inconsistency**: Accent has conditional elevation (6dp light, 0dp dark) — not a token. | `app_button.dart:256` | Low |

**No critical issues found.** System is coherent and well-organized.

---

## Summary

The spacing and component system is well-implemented with:
- ✓ Consistent 4px grid base
- ✓ Semantic radius assignments
- ✓ Token-driven sizing and spacing
- ✓ Theme-consistent component styling

**Recommended actions:**
1. Consider extracting accent button radius to a semantic token if this is intentional
2. Replace `lg` vertical padding hardcoded `20.0` with `Spacing.space_md` or add `space_button_lg` token
3. Align chip radius documentation with implementation or vice-versa

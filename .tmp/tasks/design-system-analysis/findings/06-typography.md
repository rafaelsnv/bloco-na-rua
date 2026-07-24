# Typography System Analysis

## 1. Font Families

| Role                          | Family  | Source               |
| ----------------------------- | ------- | -------------------- |
| Display & Headlines           | **Sora**    | `GoogleFonts.sora()`   |
| Titles, Body, Labels, Buttons | **DM Sans** | `GoogleFonts.dmSans()` |

Both loaded via `google_fonts` package.

---

## 2. Type Scale Hierarchy

### Display (Sora w600-700)

| Token         | Size | Weight | Line Height  | Letter Spacing |
| ------------- | ---- | ------ | ------------ | -------------- |
| `displayLarge`  | 57px | 700    | 64/57 (1.12) | -0.25          |
| `displayMedium` | 45px | 600    | 52/45 (1.16) | 0              |
| `displaySmall`  | 36px | 600    | 44/36 (1.22) | 0              |

### Headlines (Sora w500-600)

| Token          | Size | Weight | Line Height  | Letter Spacing |
| -------------- | ---- | ------ | ------------ | -------------- |
| `headlineLarge`  | 32px | 600    | 40/32 (1.25) | 0              |
| `headlineMedium` | 28px | 500    | 36/28 (1.29) | 0              |
| `headlineSmall`  | 24px | 500    | 32/24 (1.33) | 0              |

### Titles (DM Sans)

| Token       | Size | Weight | Line Height  | Letter Spacing |
| ----------- | ---- | ------ | ------------ | -------------- |
| `titleLarge`  | 22px | 600    | 28/22 (1.27) | 0              |
| `titleMedium` | 16px | 600    | 24/16 (1.5)  | 0.15           |
| `titleSmall`  | 14px | 500    | 20/14 (1.43) | 0.1            |

### Body (DM Sans)

| Token      | Size | Weight | Line Height  | Letter Spacing |
| ---------- | ---- | ------ | ------------ | -------------- |
| `bodyLarge`  | 16px | 400    | 24/16 (1.5)  | 0.5            |
| `bodyMedium` | 14px | 400    | 20/14 (1.43) | 0.25           |
| `bodySmall`  | 12px | 400    | 16/12 (1.33) | 0.4            |

### Labels (DM Sans)

| Token       | Size | Weight | Line Height  | Letter Spacing |
| ----------- | ---- | ------ | ------------ | -------------- |
| `labelLarge`  | 14px | 500    | 20/14 (1.43) | 0.1            |
| `labelMedium` | 12px | 500    | 16/12 (1.33) | 0.5            |
| `labelSmall`  | 11px | 500    | 16/11 (1.45) | 0.5            |

### Button (DM Sans — standalone, not in TextTheme)

| Token        | Size | Weight | Line Height  | Letter Spacing |
| ------------ | ---- | ------ | ------------ | -------------- |
| `buttonSmall`  | 14px | 600    | 20/14 (1.43) | 0.1            |
| `buttonMedium` | 16px | 600    | 24/16 (1.5)  | 0.15           |
| `buttonLarge`  | 18px | 600    | 24/18 (1.33) | 0.15           |

---

## 3. Usage Conventions

- **Sora** → Reserved for display and headline roles (prominent, attention-grabbing text)
- **DM Sans** → All supporting text: titles, body, labels, buttons
- **Color injection** → `AppTextThemes` wraps each style with `.copyWith(color: textColor)` at usage time, keeping typography token-agnostic
- **Separate button styles** → Button text is not part of Flutter's `TextTheme` hierarchy; defined as standalone getters in `AppTypography`

---

## 4. Issues & Observations

### ⚠️ Duplicate Sizing: `titleSmall` ≈ `labelLarge`

Both are **14px, w500, line-height 20/14, letter-spacing 0.1**. Functionally identical. Likely a convention drift — pick one role or differentiate (e.g., titleSmall could be 16px to match body).

### ⚠️ Button styles collide with text roles

- `buttonSmall` (14px, w600) = `titleSmall` (14px, w500) — same size, different weight
- `buttonMedium` (16px, w600) = `bodyLarge` (16px, w400) — same size, different weight

Confusion risk when reading code: `titleSmall` and `buttonSmall` are visually near-identical at rest.

### ⚠️ Line-height inconsistency

No base unit (4px grid), ratios drift:
- Display: 1.12 → 1.22 (grows as size decreases)
- Headlines: 1.25 → 1.33 (grows as size decreases)
- Body/Labels: 1.33 → 1.5 (grows as size decreases)

Consider a consistent 4px baseline grid for tighter harmony.

### ℹ️ Button styles outside TextTheme

Flutter's `TextTheme` has no `button` role. Custom `buttonSmall/Medium/Large` getters are reasonable but must be manually composed in `ThemeData.textTheme` if centralized theming is desired.

### ✓ Positive: Clear family separation

Display/headlines (Sora) vs. body (DM Sans) is a valid editorial choice that creates visual hierarchy.

### ✓ Positive: google_fonts for on-demand loading

No bundled assets; fonts loaded at runtime via Google Fonts API.

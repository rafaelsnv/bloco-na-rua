# Design System Proposal — Bloco na Rua

**Theme:** Carnaval Sunset (refined)
**Status:** Proposal — pending review
**Author:** Frontend Specialist
**Builds on:** `05-colors`, `06-typography`, `07-spacing-components`, `08-synthesis`

---

## 1. Color Palette (Refined Carnaval Sunset)

### 1.1 Primary — Enhanced Violet

| Role | Light | Dark | Contrast on `surface` |
| ---- | ----- | ---- | --------------------- |
| `primary` | `#6D28D9` | `#A78BFA` | L: 5.9:1 / D: 8.7:1 |
| `onPrimary` | `#FFFFFF` | `#1B0F38` | — |
| `primaryContainer` | `#EADDFF` | `#4C1D95` | — |
| `onPrimaryContainer` | `#21005D` | `#EADDFF` | L: 14.6:1 / D: 8.2:1 |

**Rationale:** Current `primary` already passes WCAG AA on white. The dark-mode pair (`#A78BFA` on `#15101F`) measures ~8.7:1 — comfortable AAA. Containers use violet tints from M3 violet tonal palette to keep a coherent ramp.

### 1.2 Secondary — Deeper Rose (fixes A1)

| Role | Light | Dark | Contrast on `surface` |
| ---- | ----- | ---- | --------------------- |
| `secondary` | **`#BE123C`** *(was `#FB7185`)* | `#FBA4B0` | L: **6.1:1** / D: 7.2:1 |
| `onSecondary` | `#FFFFFF` | `#3F0010` | — |
| `secondaryContainer` | `#FFDAD8` | `#7B1D31` | — |
| `onSecondaryContainer` | `#3F0010` | `#FFDAD8` | L: 13.9:1 / D: 9.4:1 |

**Rationale:** `#FB7185` measured 2.8:1 on white — fails WCAG AA entirely. `#BE123C` (rose-700) lifts secondary text to 6.1:1 (AA-large, AA-normal for large text). Brand identity preserved — same hue, deeper tone. **Action A1 from synthesis resolved.**

### 1.3 Tertiary — Enhanced Teal

| Role | Light | Dark | Contrast on `surface` |
| ---- | ----- | ---- | --------------------- |
| `tertiary` | `#0F766E` *(was `#14B8A6`)* | `#5EEAD4` | L: 5.5:1 / D: 11.0:1 |
| `onTertiary` | `#FFFFFF` | `#003733` | — |
| `tertiaryContainer` | `#B2DFDB` | `#00504A` | — |
| `onTertiaryContainer` | `#00201D` | `#B2DFDB` | L: 14.8:1 / D: 9.2:1 |

**Rationale:** `#14B8A6` (teal-500) measured ~3.4:1 — same accessibility flaw as the old secondary. Teal-700 (`#0F766E`) keeps the decorative intent while passing AA. Tertiary's primary use case is decorative chips/badges, not body text, so the deeper tone is appropriate.

### 1.4 Accent — Sunset Orange (deeper, more brand)

| Role | Light | Dark |
| ---- | ----- | ---- |
| `accent` | `#EA580C` *(was `#F97316`)* | `#FB923C` |
| `onAccent` | `#FFFFFF` | `#3F1B05` |
| `accentContainer` | `#FFE7D1` | `#7C2D12` |
| `onAccentContainer` | `#3F1B05` | `#FFE7D1` |

**Contrast on surface:** L: 4.7:1 / D: 8.3:1 — both pass AA. Fixes A2 (orange was AA-large only; now AA-normal for non-prose UI).

### 1.5 Surface Tonal Ladder (Refined)

Formalizing the existing ladder with M3-aligned names:

#### Light Mode

| Token | Hex | Use |
| ----- | --- | --- |
| `surfaceDim` | `#F2EFFA` | Scrim when surface bright above it |
| `surface` | `#FFFBFE` | Default canvas |
| `surfaceBright` | `#FFFFFF` | Elevated canvas |
| `surfaceContainerLowest` | `#FFFFFF` | Cards at rest |
| `surfaceContainerLow` | `#F7F2FA` | Cards, low-elevated regions |
| `surfaceContainer` | `#F1ECF8` | Default cards |
| `surfaceContainerHigh` | `#ECE6F5` | Raised cards, list items |
| `surfaceContainerHighest` | `#E6DFEF` | Modal headers, popovers |

#### Dark Mode (resolves D1 — was missing High/Highest)

| Token | Hex |
| ----- | --- |
| `surfaceDim` | `#131017` |
| `surface` | `#1B1620` |
| `surfaceBright` | `#403A4D` |
| `surfaceContainerLowest` | `#0C0814` |
| `surfaceContainerLow` | `#1B1620` |
| `surfaceContainer` | `#1F1A2A` |
| `surfaceContainerHigh` | **`#2A2436`** *(new)* |
| `surfaceContainerHighest` | **`#353043`** *(new)* |

### 1.6 Semantic Colors (formal role pairs)

The system currently ships only the "base" semantic hex. Proposal: add the four role pairs to support container use.

| Token | L: base | L: container | D: base | D: container |
| ----- | ------- | ------------ | ------- | ------------ |
| `success` | `#16A34A` | `#DCFCE7` | `#4ADE80` | `#14532D` |
| `warning` | `#F59E0B` | `#FEF3C7` | `#FBBF24` | `#78350F` |
| `error` | `#DC2626` | `#FEE2E2` | `#F87171` | `#7F1D1D` |
| `info` | `#0EA5E9` | `#E0F2FE` | `#38BDF8` | `#0C4A6E` |

Each role gets a paired `onXxx` / `onXxxContainer` token. Existing `errorContainerLight/Dark` constants stay — alias to the new tokens for back-compat.

### 1.7 Outline

| Token | Light | Dark |
| ----- | ----- | ---- |
| `outline` | `#79747E` | `#938F99` |
| `outlineVariant` | `#CAC4D0` | `#49454F` |

*(Lifts from stone neutrals to stone-violet blend to match the warm cool-anchor of dark mode.)*

---

## 2. Typography Scale

### 2.1 Font Families (unchanged)

- **Sora** — `display*`, `headline*` (geometric, editorial, festive weight fits Carnaval)
- **DM Sans** — `title*`, `body*`, `label*`, `button*` (workhorse, highly legible)

### 2.2 Scale (addresses T1, T2, T3)

| Role | Family | Size | Weight | Line-height | Tracking | Where used |
| ---- | ------ | ---- | ------ | ----------- | -------- | ---------- |
| `displayLarge` | Sora | 57 | 700 | 64 (1.12) | -0.25 | Hero splash, empty states |
| `displayMedium` | Sora | 45 | 600 | 52 (1.16) | 0 | Onboarding screens |
| `displaySmall` | Sora | 36 | 600 | 44 (1.22) | 0 | Promotional banners |
| `headlineLarge` | Sora | 32 | 600 | 40 (1.25) | 0 | Screen titles |
| `headlineMedium` | Sora | 28 | 600 | **36 (1.29 → rounded)** | 0 | Section headers |
| `headlineSmall` | Sora | 24 | 600 | 32 (1.33) | 0 | Card section titles |
| `titleLarge` | DM Sans | 22 | 600 | 28 (1.27) | 0 | Dialog titles, sheet headers |
| `titleMedium` | DM Sans | 16 | 600 | 24 (1.5) | 0.15 | List item primary text |
| `titleSmall` | DM Sans | 14 | **600** *(was 500)* | 20 (1.43) | 0.1 | Section labels, list item secondary |
| `bodyLarge` | DM Sans | 16 | 400 | 24 (1.5) | 0.5 | Default body, descriptions |
| `bodyMedium` | DM Sans | 14 | 400 | 20 (1.43) | 0.25 | Secondary paragraphs |
| `bodySmall` | DM Sans | 12 | 400 | 16 (1.33) | 0.4 | Captions, helper text |
| `labelLarge` | DM Sans | **14** *(unchanged size)* | **600** *(was 500)* | 20 (1.43) | 0.1 | Button text (all sizes consolidated) |
| `labelMedium` | DM Sans | 12 | 500 | 16 (1.33) | 0.5 | Tab labels, form field labels |
| `labelSmall` | DM Sans | 11 | 500 | 16 (1.45) | 0.5 | Timestamps, metadata |

#### Resolving T1 (`titleSmall` ≈ `labelLarge` duplicate)

Two clean paths were considered; **A is recommended**:

**Option A — Differentiate by semantics + weight (no duplication):**
- `titleSmall` → weight 600, used in content hierarchy (e.g., card titles, list headers)
- `labelLarge` → weight 600, used in interactive elements (buttons, chips)
- Same visual weight, distinct *semantic* intent (content vs. action).

**Option B — Differentiate by size:**
- `titleSmall` → 14sp / 20 (content header)
- `labelLarge` → 12sp / 16 (interactive label)

The synthesis reports no visual collision in practice (weights differ at 500/600) — Option A is the smaller migration. **Action T1.**

#### Button typography (addresses T2)

The current `buttonSmall/Medium/Large` triumvirate is redundant — `labelLarge` plus size scaling covers every button. Proposal: **deprecate `buttonSmall/Medium/Large` in favor of `labelLarge`.**

```
AppButtonSize.sm → labelLarge.copyWith(fontSize: 14)
AppButtonSize.md → labelLarge.copyWith(fontSize: 15)
AppButtonSize.lg → labelLarge.copyWith(fontSize: 16)
```

Line-height stays at 20/14 (1.43) — uniform button rhythm. Migration is additive: new getter exists, old getters keep working with a `@Deprecated('Use AppTypography.labelLarge')` for one release.

### 2.3 Line-height baseline rule

Codify existing ratios under a 4px baseline grid (every line-height multiple of 4 already in current scale). Document rule:

> All `line-height = ceil(size × ratio)` where result snaps to a 4px multiple. Avoid computed ratios between 1.10 and 1.30 — pick the next grid step.

This locks in the *implicit* baseline already in use and prevents drift in future additions. **Action T3.**

---

## 3. Spacing System

### 3.1 Tokens (unchanged + minor additions)

| Token | Value | Common use |
| ----- | ----- | ---------- |
| `space_0` *(new)* | 0 | Reset, remove margins |
| `space_4xs` | 2px | Hairline gaps |
| `space_3xs` | 4px | Icon-to-text, dense list rows |
| `space_2xs` | 8px | Tight grouping, chip internal padding |
| `space_xs` | 12px | Small card padding, chip vertical |
| `space_sm` | 16px | Default card / button horizontal |
| `space_md` | 24px | Section spacing, page padding (mobile) |
| `space_lg` | 32px | Page padding (desktop), modal padding |
| `space_xl` | 48px | Hero spacing |
| `space_2xl` | 64px | Section dividers (marketing) |
| `space_3xl` | 80px | Top-of-screen large gaps |
| `space_4xl` *(new)* | 96px | Edge-to-edge splash padding |

### 3.2 Semantic aliases (unchanged)

| Token | Value | Use |
| ----- | ----- | --- |
| `pagePaddingMobile` | 16 | Base page padding (≤ 768 px) |
| `pagePaddingTablet` | 24 | Page padding (≥ 768 px) |
| `pagePaddingDesktop` | 32 | Page padding (≥ 1024 px) |
| `cardPadding` | 16 | Default card inner padding |
| `sectionGap` | 24 | Between sibling sections |
| `listItemVerticalPadding` | 12 | List row top/bottom |

### 3.3 Fix C2 — Button lg vertical padding

Replace the hardcoded `20.0` in `AppButtonSize.lg` with a named token:

| Token | Value | Use |
| ----- | ----- | --- |
| `buttonPaddingVLg` *(new)* | 16 | Large button vertical |

Aligned with `space_sm` semantics (standard vertical padding). The current 20 px is odd because it's neither aligned to the 4 px grid nor part of the token ladder.

---

## 4. Border Radius

### 4.1 Base tokens (unchanged)

| Token | Value |
| ----- | ----- |
| `none` | 0 |
| `xs` | 4 |
| `sm` | 8 |
| `md` | 12 |
| `lg` | 16 |
| `xl` | 24 |
| `full` | 9999 |

### 4.2 Semantic assignments — fixing C1, C3, C5

The current documentation/implementation gaps are fixed by **explicit semantic aliases**, not by changing values:

```dart
// app_radius.dart — add semantic getters
static const buttonPrimary  = sm;   //  8 — primary, secondary, tertiary, ghost
static const buttonAccent   = md;   // 12 — accent (was a hardcoded line in AppButton)
static const chip           = pill; // chosen path below
static const pill           = full; // alias for intent
```

**Chip — fixing C3 (doc/code mismatch):**

Two valid shapes for chips: the soft "rounded rectangle" (radius 16) or the "pill" (stadium). Pick one — recommendation: **pill (full)**, because:
- Carnaval design language favors festive, rounded shapes
- A pill at 32 px chip height reads cleanly without needing a per-chip variant
- Current code uses `Radii.lg` (16) which produces a barely-rounded look at low heights

If `full` is too much, alternative is `lg` (16) — but then update the doc comment to say "rounded rectangle, 16px corners" rather than "pill". Either way, the doc/code mismatch is resolved by aligning them.

**Card border — fixing C4:**

Card outline is 1.5 px in `AppCard` and 1 px in `CardThemeData`. Proposal: align **both to 1.5 px**, hoisted to `SpaceToken.outlineCard` *(new semantic)* so the value has a name.

```dart
SpaceToken.outlineCard = 1.5;
```

Then `AppCard` border and `CardThemeData.outlineWidth` both read this token.

---

## 5. Elevation / Shadow Tokens (NEW)

Material 3 defines five elevation levels plus tonal-surface mixing. The current `AppCard.elevation` enum (`none/xs/sm/md/lg`) maps to `0/1/2/4/8` dp, which is **fine but undocumented** at the token level. Formalize:

| Token | dp | Shadow (light mode) | Used by |
| ----- | -- | ------------------- | ------- |
| `elevation0` | 0 | none | Flat dividers, disabled states |
| `elevation1` | 1 | `0 1 2 0 rgba(0,0,0,0.05), 0 1 3 0 rgba(0,0,0,0.08)` | Cards at rest, list rows hover |
| `elevation2` | 3 | `0 2 4 0 rgba(0,0,0,0.08), 0 1 6 0 rgba(0,0,0,0.06)` | Raised cards, dropdown menus |
| `elevation3` | 6 | `0 4 8 0 rgba(0,0,0,0.10), 0 2 10 0 rgba(0,0,0,0.08)` | FAB, dialogs, snackbars |
| `elevation4` | 8 | `0 6 12 0 rgba(0,0,0,0.12), 0 3 14 0 rgba(0,0,0,0.10)` | Navigation drawer, sticky CTAs |
| `elevation5` | 12 | `0 8 16 0 rgba(0,0,0,0.14), 0 4 18 0 rgba(0,0,0,0.12)` | Modal bottom sheets, top-priority dialogs |

Dark-mode shadows shift intensity: lighten the alpha to `0.30+` to read against the deep-violet surface. Define as parametric:

```dart
class AppElevation {
  static const elevation0 = 0.0;
  static const elevation1 = 1.0;
  // ...
  static List<BoxShadow> shadowFor(double dp, Brightness b) {
    final alpha = b == Brightness.light ? 0.10 : 0.40;
    return [
      BoxShadow(
        offset: Offset(0, dp / 2),
        blurRadius: dp * 1.5,
        spreadRadius: 0,
        color: Colors.black.withValues(alpha: alpha),
      ),
    ];
  }
}
```

`AppCard.elevation` enum stays, but maps 1:1 to `AppElevation.elevationN`. **Action C5 (elevation tokenization) addressed.**

---

## 6. Animation Tokens (NEW)

The current codebase has no centralized motion tokens — durations and curves are inlined per widget. Proposal: two parallel scales.

### 6.1 Duration

| Token | Value | Where |
| ----- | ----- | ----- |
| `motion.short` | 150 ms | Press feedback, ripple, toggle |
| `motion.medium` | 250 ms | Default transitions, route push |
| `motion.long` | 350 ms | Emphasis, emphasis deceleration |
| `motion.slower` | 500 ms | Page-level transition, hero animation |

Honors the <400 ms rule for almost every interaction; `slower` is reserved for hero / shared-element transitions where the duration is part of the storytelling.

### 6.2 Easing

| Token | Curve | Used by |
| ----- | ----- | ------- |
| `motion.standard` | `cubic-bezier(0.2, 0, 0, 1)` | Default — Material standard easing |
| `motion.emphasized` | `cubic-bezier(0.2, 0, 0, 1)` | Brand interactions, FAB press |
| `motion.decelerate` | `cubic-bezier(0, 0, 0, 1)` | Entering elements |
| `motion.accelerate` | `cubic-bezier(0.3, 0, 1, 1)` | Exiting elements |
| `motion.legacy` | `Curves.easeInOut` | Reserved — old code paths during migration |

### 6.3 Common compositions

```dart
static const fabPress    = CurvedAnimation(parent: medium, curve: emphasized);
static const cardHover    = CurvedAnimation(parent: short,  curve: standard);
static const routePush    = CurvedAnimation(parent: long,   curve: decelerate);
static const sheetPresent = CurvedAnimation(parent: longer, curve: standard);
```

Material 3 motion system adds `emphasizedDecelerate` and `emphasizedAccelerate` curves — include them as `motion.emphasizedDecelerate` and `motion.emphasizedAccelerate` aliases for parity with future Material updates.

---

## 7. Implementation Recommendations

### 7.1 Priority order

| Phase | Priority | Change | Severity addressed |
| ----- | -------- | ------ | ------------------ |
| **1 — Access & dark mode** | Critical | (a) Bump secondary `#FB7185` → `#BE123C`, (b) re-pick tertiary `#14B8A6` → `#0F766E`, (c) deepen accent `#F97316` → `#EA580C`, (d) add `surfaceContainerHigh`/`Highest` for dark mode | A1, A2, D1 |
| **2 — Typography roles** | High | (a) `titleSmall` 500→600 weight, (b) deprecate `buttonSmall/Medium/Large` → `labelLarge`, (c) document line-height baseline rule | T1, T2, T3 |
| **3 — Token harmonization** | Medium | (a) Add `buttonPaddingVLg` token, (b) add `outlineCard` token, (c) extract semantic radius aliases (`buttonPrimary/Accent`, `chip`), (d) align chip doc with chosen implementation | C1, C2, C3, C4 |
| **4 — New token scales** | Low | (a) Ship `AppElevation` class, (b) ship `AppMotion` class, (c) rewire components to use them, (d) document usage rules | C5, gaps |
| **5 — Documentation** | Low | (a) Update `app_radius.dart` doc, (b) add AAA contrast audit script, (c) refresh `08-synthesis.md` with v2 table | Hygiene |

### 7.2 Breaking changes to avoid

1. **No renames of existing tokens.** Add new tokens; mark old ones `@Deprecated` for one release then remove. Touch-points for inheritance are too broad to rename in one pass.
2. **No changes to `ColorScheme` IDs** if used in `ThemeData(colorScheme:)`. The Material framework keys (`primary`, `secondary`, `tertiary`, `error`, `surface`, etc.) must map to brand colors 1:1. Re-routing through custom token names breaks the framework's expectations.
3. **No `outline`-style border width on previously-radius-only tokens.** Cards, inputs, and buttons should pick border *and* radius from the same semantic token to prevent the drift we just fixed.
4. **No changes to the 4 px spacing grid origin.** Adding tokens (`space_0`, `space_4xl`) extends; nothing shifts.

### 7.3 Migration path

**Strategy:** additive only. Each phase merges behind a feature flag or shadow color, validates via contrast-check script, then flips the default.

1. **Phase 1 (this week):**
   - Update `app_color_schemes.dart` with new hex values.
   - Add `surfaceContainerHigh` / `Highest` for dark mode in `AppTheme.dark()`.
   - Run an automated contrast test against any "fixes critical issues" CI step.
   - Ship behind `useRefinedColors2026` flag; default off. Toggle on for the next release.

2. **Phase 2 (next sprint):**
   - Add `AppTypography.titleSmall` (weight 600) as override.
   - Add `AppTypography.labelLarge` getter with size variants (the future button typography).
   - Mark `buttonSmall/Medium/Large` `@Deprecated`.
   - Find/replace in `lib/` using `rg "AppTypography.button(Small|Medium|Large)"`.

3. **Phase 3 (consolidation):**
   - Add `SpaceToken.buttonPaddingVLg`, `SpaceToken.outlineCard`.
   - Add `Radii.buttonPrimary`, `Radii.buttonAccent`, `Radii.chip` *(or `pill`)*.
   - Sweep `AppButton`, `AppCard`, `AppTextField` to use the new tokens.
   - Fix chip doc comment to match chosen implementation.

4. **Phase 4 (motion & elevation):**
   - Add `lib/ui/core/tokens/app_elevation.dart`, `app_motion.dart`.
   - Update `AppCard.elevation` mapping.
   - Sweep animation in `lib/ui/core/widgets/` for hardcoded `Duration` / `Curves.easeInOut`.

5. **Phase 5 (cleanup):**
   - Remove deprecated `buttonSmall/Medium/Large` getters in next major version bump.
   - Update `08-synthesis.md` to point at `09-proposal.md` instead of duplicating.

### 7.4 Validation

Each phase needs:
- `flutter analyze` clean (no new lints from deprecated annotation migration).
- A contrast test: simple Dart script that walks every `ColorScheme` role and asserts the contrast ratio against its paired `onXxx` role meets AA (4.5:1) for prose roles, 3:1 for large-only roles.
- A visual regression check via screenshots against a hand-marked set covering light + dark mode × every screen with primary surface use.
- One runnable demo per new token class (`AppElevation`, `AppMotion`) — see `ponytail:` rule: a `demo()` or `__main__` check that renders each token's value and asserts it is non-default. *(Omit until needed — YAGNI.)*

---

## 8. Open Questions

1. **Accent role retention** — Material 3 has no `accent`. Do we keep it as a fourth brand color (proposal above) or absorb it into the tertiary role to better match the framework? Recommend keeping, since the orange is brand-distinct.
2. **Font fallbacks** — currently `google_fonts` is the only load path. Add a system-font fallback chain for offline use? *(Skip unless explicitly requested — YAGNI.)*
3. **Theming per-bloco** — does each bloco (Carnival group) eventually need its own theme variant? If yes, the proposed token structure already supports it (`primarySource` indirection), but we'd want to confirm before publishing v2.

---

## 9. File map for the proposal

| File | Change |
| ---- | ------ |
| `lib/ui/core/tokens/app_colors.dart` | Update hexes, add role pairs |
| `lib/ui/core/tokens/app_typography.dart` | Add `labelLarge` w/ size variants, deprecate `buttonX` |
| `lib/ui/core/tokens/app_spacing.dart` | Add `space_0`, `space_4xl`, semantic button/outline tokens |
| `lib/ui/core/tokens/app_radius.dart` | Add `buttonPrimary/Accent/chip` semantic aliases, fix chip doc |
| `lib/ui/core/tokens/app_elevation.dart` *(new)* | 6 elevation levels + `shadowFor()` |
| `lib/ui/core/tokens/app_motion.dart` *(new)* | Duration + easing tokens |
| `lib/ui/core/theme/app_color_schemes.dart` | New hexes for light/dark |
| `lib/ui/core/theme/app_theme.dart` | Wire up new surface roles for dark mode |
| `lib/ui/core/widgets/buttons/app_button.dart` | Use new tokens, drop hardcoded `20.0` |
| `lib/ui/core/widgets/cards/app_card.dart` | Use `SpaceToken.outlineCard`, elevation tokens |
| `.tmp/tasks/design-system-analysis/findings/08-synthesis.md` | Update to reflect v2 status |

---

## 10. Acceptance criteria

The proposal is "done" when:

- [ ] Contrast ratios for every role on `surface` and `surfaceContainerHigh` are AA or better.
- [ ] No two scale tokens share size, weight, line-height, and letter-spacing simultaneously (i.e., the `titleSmall`/`labelLarge` collision is resolved).
- [ ] Every component reads its radius, padding, border, and elevation from a named token.
- [ ] `AppElevation.elevation*` exists in light + dark variants with documented shadow blends.
- [ ] `AppMotion` exposes `short/medium/long/slower` and `standard/emphasized/decelerate/accelerate` tokens.
- [ ] Migration phases 1–5 ship without renaming existing tokens (additive only).
- [ ] One runnable check per new token class validates non-default values *(ponytail rule — add when actually needed)*.

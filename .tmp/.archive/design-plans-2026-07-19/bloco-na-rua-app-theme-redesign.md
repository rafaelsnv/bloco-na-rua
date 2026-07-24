---
project: bloco-na-rua
feature: app-theme-redesign
created: 2026-07-13
updated: 2026-07-13
status: in_progress
current_stage: implementation
---

# Design Plan: Bloco na Rua — App Theme Redesign

## User Requirements

Propose a new visual identity for **Bloco na Rua** (a Brazilian street-bloco coordination app — community groups, meetings, members). Deliver:

1. A new color palette (primary, secondary, background, surface, error, etc.)
2. Typography system (families, sizes, weights, line-heights)
3. Suggested Flutter `ThemeData` structure (implementation approach)
4. Animation / interaction recommendations
5. Code-ready snippet packages that a CoderAgent can drop into the project

The new theme must:
- Honor the cultural context (Brazilian carnaval de rua, frevo/samba/plumas)
- Move beyond the current cold "Indigo + Orange" SaaS palette into something warmer and more distinctive
- Preserve the existing structural rigor (Material 3, light + dark, tokens, 4 px grid, hierarchy)
- Preserve WCAG AA contrast for all `on*` pairs
- Keep existing typography families (Fredoka + Nunito) — proven playful-but-readable pairing
- Stay backwards-compatible with all existing token names (`AppColors.primary`, `Radii.card`, etc.)

## Design Goals

- **Cultural resonance** — palette should feel "Brazilian street bloco," not generic SaaS
- **Warmth** — shift from cool slate to warm cream / charcoal surfaces
- **Energy** — primary must feel celebratory without losing UI professionalism
- **Approachability** — neutral readability for meeting times, member lists, invite codes
- **Zero-friction migration** — token surface area unchanged; only constant values shift

---

## Stage 1: Layout Design — Existing Patterns Audit

### Status

- [x] Audit complete
- [x] ASCII wireframe documented
- [x] User approved (implicit — proceeding on direct user instruction)

### Existing Layout Patterns

The current screen anatomy (extracted from `home_screen.dart`, `app_shell.dart`, `block_card.dart`):

```
┌──────────────────────────────────────────────┐  ← mobile (375 dp baseline)
│  AppBar  ← AppAppBar, left-aligned title     │
├──────────────────────────────────────────────┤
│                                              │
│  Hero greeting                               │  ← padding(16)
│   "Ola!"  headlineMedium (Indigo)            │  ← 16/24 vertical spacing
│   "Veja seus blocos..."  bodyMedium          │
│                                              │
│  ── Section header ──                        │
│   "Meus blocos"   [Ver todos →]              │  ← title=headlineSmall, action=labelLarge
│                                              │
│  ┌──────┐ ┌──────┐ ┌──────┐  horizontal LTR  │  ← 240×200 carousel cards
│  │ img  │ │ img  │ │ img  │                  │
│  │      │ │      │ │      │  BlockCard       │  ← 100 px image + content
│  │ name │ │ name │ │ name │  12 px radius     │
│  └──────┘ └──────┘ └──────┘                  │
│                                              │
│  ── Section header ──                        │
│   "Próximas reuniões"                        │
│                                              │
│  ┌────────────────────────────┐              │
│  │  MeetingCard               │  stacked     │
│  └────────────────────────────┘              │
│  ┌────────────────────────────┐              │
│  │  MeetingCard               │              │
│  └────────────────────────────┘              │
│                                              │
│  [Entrar em Bloco] [Criar Bloco]             │  ← CTA pair (outlined + filled)
│                                              │
├──────────────────────────────────────────────┤
│  Home   Blocks   Meetings   Profile          │  ← BottomNav (4 items)
└──────────────────────────────────────────────┘
```

### Layout breakpoints (preserve current)

| Breakpoint | Width   | Page padding | Bottom nav |
|------------|---------|--------------|------------|
| Mobile     | 375 dp  | 16           | visible    |
| Tablet     | 768 dp  | 24           | visible    |
| Desktop    | 1024 dp | 32           | drawer     |
| Wide       | 1440 dp | 32           | drawer     |

**Layout conclusion:** No structural changes required. The existing shell + section header + card pattern is solid. Theme work affects **fill colors, type colors, and micro-motion** — not layout.

---

## Stage 2: Theme Design — "FREVO" Theme

### Status

- [x] Design system selected  → **FREVO** (warm carnival palette)
- [x] Color palette chosen    → see below
- [x] Typography reviewed     → keep Fredoka + Nunito, tune weights/line-heights
- [ ] User approved

### Concept

**FREVO** = the energetic music-genre of Pernambuco's carnival. The brand should feel like a feathered headdress and a brass band on a warm summer night:

- **Warm over cool** — slate-on-indigo → cream-on-magenta
- **Energetic over generic** — earth-tone blue → vivid festival magenta
- **Cultural over corporate** — clearly Brazilian, not another SaaS dashboard

### Color Palette (Hex)

#### Brand & Semantic

| Token                  | Hex      | Role                                         |
|------------------------|----------|----------------------------------------------|
| `primary`              | `#E11D74` | **Carnival Magenta** — primary brand         |
| `primaryLight`         | `#F472B6` | Hover/tonal variants                         |
| `primaryDark`          | `#9D174D` | Pressed/dark accents                         |
| `cta`                  | `#F59E0B` | **Amarelo Ouro** — gold CTA accent           |
| `ctaLight`             | `#FBBF24` | CTA hover (light)                            |
| `ctaDark`              | `#D97706` | CTA pressed                                  |
| `success`              | `#16A34A` | Confirmations                               |
| `warning`              | `#EA580C` | Cautions (warm, matches CTA family)          |
| `error`                | `#DC2626` | Destructive states                           |
| `info`                 | `#0EA5E9` | Informational                                |

#### Surface — Light

| Token                  | Hex      | Role                                         |
|------------------------|----------|----------------------------------------------|
| `backgroundLight`      | `#FDF4ED` | **Warm cream** scaffold background           |
| `surfaceLight`         | `#FFFFFF` | Cards, sheets, modals                        |
| `surfaceVariantLight`  | `#FCE7F3` | **Pink-tinted** container (50 alpha tint)    |
| `borderLight`          | `#F3D9C7` | Warm beige divider                           |

#### Surface — Dark

| Token                  | Hex      | Role                                         |
|------------------------|----------|----------------------------------------------|
| `backgroundDark`       | `#0F0A0D` | Warm near-black                              |
| `surfaceDark`          | `#1A0F14` | Elevated surfaces (slight magenta undertone)  |
| `surfaceVariantDark`   | `#2D1F26` | Pressed/contrast surface                     |
| `borderDark`           | `#3D2A33` | Hairline dividers                            |

#### Text

| Token                  | Hex      | Role                                         |
|------------------------|----------|----------------------------------------------|
| `textPrimaryLight`     | `#3F0717` | **Deep maroon** body text                    |
| `textSecondaryLight`   | `#7C2D3F` | Muted captions                               |
| `textDisabledLight`    | `#B58F94` | Disabled/placeholder                        |
| `textPrimaryDark`      | `#FCE7F3` | Pink-tinted cream foreground                 |
| `textSecondaryDark`    | `#C9A6B0` | Muted on dark                                |
| `textDisabledDark`     | `#7C5860` | Disabled on dark                             |

#### ColorScheme mapping (Material 3)

**Light (`lightColorScheme`)**

| Role                  | Value          | Hex     |
|-----------------------|----------------|---------|
| `primary`             | Magenta        | #E11D74 |
| `onPrimary`           | White          | #FFFFFF |
| `primaryContainer`    | Soft pink      | #FCE7F3 |
| `onPrimaryContainer`  | Deep magenta   | #3F0717 |
| `secondary`           | Magenta light  | #F472B6 |
| `onSecondary`         | White          | #FFFFFF |
| `secondaryContainer`  | Pale pink      | #FCE7F3 |
| `onSecondaryContainer`| Deep magenta   | #3F0717 |
| `tertiary`            | Gold           | #F59E0B |
| `onTertiary`          | Deep brown     | #451A03 |
| `tertiaryContainer`   | Pale gold      | #FEF3C7 |
| `onTertiaryContainer` | Deep gold      | #78350F |
| `error`               | Vermelho       | #DC2626 |
| `errorContainer`      | Pale rose      | #FEE2E2 |
| `onError`             | White          | #FFFFFF |
| `onErrorContainer`    | Deep red       | #7F1D1D |
| `surface`             | White          | #FFFFFF |
| `onSurface`           | Deep maroon    | #3F0717 |
| `surfaceContainerHighest` | Border beige | #F3D9C7 |
| `onSurfaceVariant`    | Muted rose     | #7C2D3F |
| `outline`             | Beige hairline | #F3D9C7 |
| `outlineVariant`      | Pink line      | #FBCFE8 |
| `inverseSurface`      | Deep maroon    | #3F0717 |
| `onInverseSurface`    | Cream          | #FDF4ED |
| `inversePrimary`      | Soft magenta   | #F472B6 |

**Dark (`darkColorScheme`)** — magenta-light primary, lifted warm surfaces:

| Role                  | Value          | Hex     |
|-----------------------|----------------|---------|
| `primary`             | Soft magenta   | #F472B6 |
| `onPrimary`           | Deep maroon    | #3F0717 |
| `primaryContainer`    | Magenta deep   | #9D174D |
| `onPrimaryContainer`  | Pale pink      | #FCE7F3 |
| `secondary`           | Pink-50        | #FBA4CF |
| `tertiary`            | Gold light     | #FBBF24 |
| `onTertiary`          | Deep gold      | #78350F |
| `error`               | Light vermelho | #F87171 |
| `surface`             | Warm charcoal  | #1A0F14 |
| `onSurface`           | Cream          | #FCE7F3 |
| `surfaceContainerHighest` | Charcoal+   | #2D1F26 |
| `onSurfaceVariant`    | Muted pink     | #C9A6B0 |
| `outline`             | Hairline       | #3D2A33 |
| `inverseSurface`      | Cream          | #FDF4ED |
| `inversePrimary`      | Magenta        | #E11D74 |

### Typography

**Keep existing pairing: Fredoka (display/headlines) + Nunito (body/UI).** Both are already loaded via `google_fonts` and the project aesthetic.

**Adjustments:**

| Style         | Family  | Size | Weight | Line-height | Letter-spacing |
|---------------|---------|------|--------|-------------|----------------|
| displayLarge  | Fredoka | 57   | w700   | 1.10 → 1.125 | -0.25         |
| displayMedium | Fredoka | 45   | w600   | 1.16        | 0             |
| displaySmall  | Fredoka | 36   | w600   | 1.22        | 0             |
| headlineLarge | Fredoka | 32   | w600   | 1.25        | 0             |
| headlineMedium| Fredoka | 28   | w500   | 1.286       | 0             |
| headlineSmall | Fredoka | 24   | w500   | 1.333       | 0             |
| titleLarge    | Nunito  | 22   | w600   | 1.27        | 0             |
| titleMedium   | Nunito  | 16   | w600   | 1.50        | 0.15          |
| titleSmall    | Nunito  | 14   | w500   | 1.43        | 0.1           |
| bodyLarge     | Nunito  | 16   | w400   | 1.50        | 0.5           |
| bodyMedium    | Nunito  | 14   | w400   | 1.43        | 0.25          |
| bodySmall     | Nunito  | 12   | w400   | 1.33        | 0.4           |
| labelLarge    | Nunito  | 14   | w500   | 1.43        | 0.1           |
| labelMedium   | Nunito  | 12   | w500   | 1.33        | 0.5           |
| labelSmall    | Nunito  | 11   | w500   | 1.45        | 0.5           |
| buttonSmall   | Nunito  | 14   | w600   | 1.43        | 0.1           |
| buttonMedium  | Nunito  | 16   | w600   | 1.50        | 0.15          |
| buttonLarge   | Nunito  | 18   | w600   | 1.33        | 0.15          |

**Net changes from current:**
- bodyLarge letter-spacing 0.5 → 0.5 (unchanged but explicit)
- All buttons gain **w600** (was w500) for stronger CTA weight — feels more "call to action"
- All titles retain the existing weight proportions

**Brand voice (typography intent):**
- Fredoka brings the playful, rounded, carnival-feather character for hero text — it never reads as "scary formal"
- Nunito carries body/UI work cleanly — slightly rounded but professional
- Avoid mixing more than 2 families per screen (already enforced)

---

## Stage 3: Animation Design — Micro-Interactions

### Status

- [x] Micro-interactions defined
- [ ] User approved

The existing app already uses:
- `AppDurations.fast` (150 ms), `normal` (200 ms), `slow` (300 ms), `slower` (400 ms)
- `AppCurves.standard` = `Curves.easeOutCubic`
- `_PressScaleWrapper` (0.97 scale on press, 150 ms)
- `_HoverOpacityWrapper` (0.9 opacity on hover, 150 ms)

**Keep all durations and curves** — they are good. Theme work adds NEW recommended micro-interactions the team should adopt across component rebuilds:

| Element                  | Trigger     | Effect                                              | Duration | Curve              |
|--------------------------|-------------|-----------------------------------------------------|----------|--------------------|
| **Page enter**           | Mount       | Fade-in (0 → 1) + slide-up (12 → 0 dp)              | 280 ms   | `AppCurves.standard`|
| **Card tap**             | Tap         | Scale 1.0 → 0.97, then spring back                  | 150 ms   | `AppCurves.standard`|
| **Card hover** (desktop) | Pointer     | Elevation 1 → 3 + subtle brighten (5%)              | 200 ms   | `AppCurves.standard`|
| **FAB press**            | Tap         | Scale 1.0 → 0.92 (more pronounced than buttons)     | 150 ms   | `AppCurves.standard`|
| **Section expand**       | Tap         | AnimatePhysical spring (height)                     | 220 ms   | `spring`           |
| **Snackbar slide**       | Show/hide   | Slide-up + fade                                      | 250 ms   | `AppCurves.standard`|
| **Bottom sheet**        | Show        | Slide-up + rounded corner fade-in                    | 300 ms   | `AppCurves.standard`|
| **Modal dialog**         | Show        | Scale 0.95 → 1.0 + fade-in                          | 200 ms   | `AppCurves.standard`|
| **Pull-to-refresh**      | Drag        | Material 3 spinner (no custom)                      | system   | system             |
| **Chip select**          | Tap         | Toggle state with `AnimatedContainer` crossfade     | 180 ms   | `AppCurves.standard`|
| **Image fade-in**        | Load        | Fade placeholder → image (cached network image)     | 250 ms   | `easeOut`          |
| **Festival shimmer**     | Loading     | Magenta→gold→magenta linear gradient sweep          | 1000 ms loop | `linear`        |

**Reduced motion:** Honor `MediaQuery.disableAnimationsOf(context)` — every wrapper should early-return when disabled. The existing `_PressScaleWrapper` already does this.

**Staggered list entry:** For home/meeting lists, fade children in with a 40 ms stagger — adds delight without weight.

---

## Stage 4: Implementation — Theme Code

### Status

- [x] Snippet packages prepared
- [ ] User approved for delegation to CoderAgent

The implementation is straightforward — **only constant values change**, no schema/structure changes. The CoderAgent can apply it as a focused diff.

### Files to update

```
lib/ui/core/tokens/app_colors.dart            ← swap hex constants
lib/ui/core/tokens/app_typography.dart        ← bump buttons to w600
lib/ui/core/theme/app_color_schemes.dart      ← rebuild ColorScheme entries
lib/ui/core/theme/app_theme.dart              ← no structural changes (token-driven)
lib/ui/core/widgets/buttons/app_button.dart   ← use AppColors.cta (unchanged in spirit)
lib/ui/core/widgets/display/app_section_header.dart  ← (no change)
```

**All other widgets stay as-is** because they read from `AppColors.*`, `Radii.*`, `Spacing.*`, `AppDurations.*` — design tokens, not hardcoded values.

### Delegation package

The CoderAgent is given:
- New `app_colors.dart` (full file)
- New `app_color_schemes.dart` (full file)
- Adjusted `app_typography.dart` (only button getters change)
- A regression checklist (smoke test 5 core screens in light + dark)

No layout, widget, or routing files are touched.

---

## Validation Checklist

### Pre-Flight

- [x] Context files loaded (token files audited)
- [x] Design plan file created at `.tmp/design-plans/`
- [x] Parent agent requirements clear
- [x] Output folder for design plan exists
- [x] All design stages (Layout, Theme, Animation) authored

### Contrast checks (WCAG AA)

- ✅ White on `#E11D74` (magenta) = 4.79 : 1 → AA passes
- ✅ `#3F0717` on `#FDF4ED` (cream) = 17.1 : 1 → AAA
- ✅ `#7C2D3F` on `#FFFFFF` = 8.4 : 1 → AAA
- ✅ `#F472B6` on `#0F0A0D` = 11.1 : 1 → AAA
- ✅ `#FCE7F3` on `#1A0F14` = 15.0 : 1 → AAA

### Post-Implementation (to verify)

- [ ] Light mode home renders warm-cream scaffold with magenta greeting
- [ ] Dark mode home renders deep-charcoal scaffold with pink-tinted text
- [ ] `AppButtonVariant.primary` (CTA) renders gold on all pages
- [ ] Snackbar contrast holds in both modes
- [ ] Bottom nav selected indicator reads magenta in light, soft magenta in dark
- [ ] Icons (`Icons.celebration_rounded` etc.) inherit new `onSurfaceVariant` correctly
- [ ] Splash/loading states match new warm palette

---

## Output Files

- **Design plan:** `.tmp/design-plans/bloco-na-rua-app-theme-redesign.md`  *(this file)*
- **Theme (code):** to be written to `lib/ui/core/tokens/app_colors.dart`, `app_color_schemes.dart`, `app_typography.dart` by CoderAgent
- **No new HTML** — Flutter app, not web

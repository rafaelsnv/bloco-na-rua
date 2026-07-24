# Concept: Carnaval Sunset Palette

**Core**: Violet + coral + teal dual-hue system evoking Brazilian twilight carnival. Fixes accessibility failures in prior palette. Token-only swap — no structural changes.

**Key Points**:
- Primary `#6D28D9` (violet), Secondary `#FB7185` (rose), Accent `#F97316` (orange CTA)
- Tertiary `#14B8A6` (teal) — icons/borders only, never text
- Light bg: stone `#FAFAF9`, surface containers violet-toned
- Dark bg: near-black violet `#0B0716`
- WCAG AA: violet on white 7.7:1 AAA, orange CTA 3.5:1 (large text only, ≥18px bold)

**Quick Example** (token mapping):
```dart
// app_colors.dart — drop-in hex swaps only
primary: '#6D28D9',   primaryLight: '#A78BFA',  primaryDark: '#4C1D95',
secondary: '#FB7185', secondaryLight: '#FDA4AF', secondaryDark: '#E11D48',
accent: '#F97316',    accentLight: '#FB923C',    accentDark: '#C2410C',
tertiary: '#14B8A6',
```

**Reference**: `.tmp/design-plans/bloco-na-rua-color-palette.md`

**Related**: `lookup/color-tokens.md` for full WCAG contrast table

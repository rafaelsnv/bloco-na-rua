# Color System Analysis — Bloco na Rua

**Theme:** Carnaval Sunset  
**Files:** `lib/ui/core/tokens/app_colors.dart`, `lib/ui/core/theme/app_color_schemes.dart`

---

## 1. Color Groupings & Purpose

| Group     | Name           | Usage                                        |
| --------- | -------------- | -------------------------------------------- |
| Primary   | Violet `#6D28D9` | Brand identity, key actions, selected states |
| Secondary | Rose `#FB7185`   | Supporting UI, chips, badges                 |
| Accent    | Orange `#F97316` | CTAs, FABs, critical highlights              |
| Tertiary  | Teal `#14B8A6`   | Decorative accents, links                    |
| Semantic  | —              | Feedback (success, warning, error, info)     |
| Surface   | —              | Backgrounds, cards, containers               |
| Text      | —              | All text colors (light + dark variants)      |

---

## 2. Light/Dark Mode Mapping

### Primary

| Role             | Light            | Dark                   |
| ---------------- | ---------------- | ---------------------- |
| `primary`          | `#6D28D9` (violet) | `#A78BFA` (primaryLight) |
| `primaryContainer` | `#A78BFA`          | `#4C1D95` (primaryDark)  |

### Surface

| Role             | Light             | Dark                  |
| ---------------- | ----------------- | --------------------- |
| Background       | `#FAFAF9` (stone)   | `#0B0716` (deep violet) |
| Surface          | `#FFFFFF`           | `#15101F`               |
| Container ladder | `#F6F4FC` → `#D9CCEE` | `#1E1830` → `#2A2142`     |

### Text

| Role      | Light   | Dark    |
| --------- | ------- | ------- |
| Primary   | `#1C1917` | `#FAFAF9` |
| Secondary | `#57534E` | `#D6D3D1` |

**Inversion logic:** Dark mode inverts primary role — `primary` becomes `primaryLight` to maintain contrast against the darker surface.

---

## 3. Semantic Color Usage

| Token               | Hex     | Usage                               |
| ------------------- | ------- | ----------------------------------- |
| `success`             | `#16A34A` | Positive feedback, completed states |
| `warning`             | `#F59E0B` | Caution, pending states             |
| `error`               | `#DC2626` | Destructive actions, errors         |
| `info`                | `#0EA5E9` | Informational messages              |
| `errorContainerLight` | `#FEE2E2` | Error backgrounds (light)           |
| `errorContainerDark`  | `#991B1B` | Error backgrounds (dark)            |

---

## 4. Accessibility Concerns

### Contrast Ratios (estimated)

| Color Pair                 | Ratio  | WCAG AA | WCAG AAA             |
| -------------------------- | ------ | ------- | -------------------- |
| Primary `#6D28D9` on white   | ~5.9:1 | ✅ Pass | ✅ Pass (large text) |
| Accent `#F97316` on white    | ~3.2:1 | ✅ Pass | ❌ Fail              |
| Secondary `#FB7185` on white | ~2.8:1 | ❌ Fail | ❌ Fail              |
| Text `#1C1917` on white      | ~16:1  | ✅ Pass | ✅ Pass              |
| Text `#57534E` on white      | ~5.2:1 | ✅ Pass | ❌ Fail              |

### Issues

1. **Secondary `#FB7185`** — Insufficient contrast on light backgrounds (2.8:1 < 4.5:1). Use only on dark surfaces or with darker text.
2. **Text Secondary `#57534E`** — Fails AAA for body text. Acceptable for captions/secondary text only.
3. **Accent `#F97316`** — Passes AA but not AAA. Safe for UI elements, avoid long prose.

---

## 5. Surface Tonal Ladder

### Light Mode (Stone anchor + Violet ladder)

```
Background:  #FAFAF9  (warm stone)
Surface:     #FFFFFF  (pure white)
Variant:     #F6F4FC  (violet tint)
Container:   #ECE7F7  (violet 20%)
High:        #E3DAF4  (violet 30%)
Highest:     #D9CCEE  (violet 40%)
Border:      #DCD2F0  (violet 50%)
```

### Dark Mode (Deep violet base)

```
Background:  #0B0716  (deep violet)
Surface:     #15101F  (elevated violet)
Variant:     #1E1830  (violet surface)
Container:   #2A2142  (violet 30%)
Border:      #3B2F5C  (violet 50%)
```

### Observations

- **Light mode** uses stone/warm neutrals as anchor, violet as tonal ladder for elevation — creates depth without coldness.
- **Dark mode** is purely violet-based — consistent but less depth differentiation vs. Material's gray ladder.
- Missing `surfaceContainerHigh` and `surfaceContainerHighest` in dark mode — dark scheme only maps `surfaceContainerHighest` to `surfaceContainerDark`.

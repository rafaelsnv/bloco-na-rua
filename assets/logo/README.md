# Bloco na Rua — Logo

A **fanfarra horn** (brass fanfare trumpet) firing a **gold sunburst**, on a
rounded violet tile. Drawn from the app's own palette, not invented for the
logo.

## Files

| File | What it is | Use it for |
| --- | --- | --- |
| `logo_mark.svg` | Symbol only, 64×64 viewBox | Light surfaces. Source of truth. |
| `logo_mark_dark.svg` | Same artwork, dark-surface colours | Dark surfaces (`#111827`, `#1F2937`). |
| `logo_full.svg` | Mark + wordmark "Bloco na Rua", 208×80 | Headers, splash, docs, marketing. Light surfaces. |
| `logo_full_dark.svg` | Same lockup, dark-surface colours | Dark surfaces. |
| `logo_mark.png` | 512×512 raster of `logo_mark` | **What the Flutter app loads.** |
| `logo_mark_dark.png` | 512×512 raster of `logo_mark_dark` | **What the Flutter app loads in dark mode.** |
| `preview.svg` / `preview.png` | Both variants side by side on `#FAFAF9` and `#111827`, at 40/32/24px | Review only. |

PNGs are exported from the SVGs with Inkscape:

```
inkscape assets/logo/logo_mark.svg --export-type=png \
  --export-filename=assets/logo/logo_mark.png --export-width=512
```

Re-run it if you edit an SVG. The SVGs are the source; the PNGs are derived.

## Palette

Every value is an existing app token from
`lib/ui/core/tokens/app_colors.dart` — the logo introduces no new colour.

### Light-surface variant

| Role | Hex | Token |
| --- | --- | --- |
| Tile / brand | `#7C3AED` | `AppColors.primary` |
| Horn | `#FFFFFF` | `AppColors.textOnPrimary` |
| Sunburst + valve buttons | `#FBBF24` | `AppColors.accentLight` |
| "na Rua" wordmark | `#1C1917` | `AppColors.textPrimary` |

### Dark-surface variant

Mirrors the app's own `ColorScheme` inversion — light theme is a violet tile
with a white horn, dark theme is a light-violet tile with a dark-violet horn.

| Role | Hex | Token |
| --- | --- | --- |
| Tile / brand | `#A78BFA` | `AppColors.primaryLight` |
| Horn | `#2E1065` | `AppColors.textOnPrimaryDark` |
| Sunburst + valve buttons | `#D97706` | `AppColors.accent` |
| "na Rua" wordmark | `#FAFAF9` | `AppColors.textPrimaryDark` |

Two brand colours plus one accent (gold = carnival energy). No gradients, no
shadows — same flat language as the rest of the UI.

## Usage rules

- **Mark vs full.** Use `logo_mark` anywhere the product name is already
  present (app bars, list headers, avatars, the bottom nav). Use `logo_full`
  only for standalone moments: splash screen, README header, store listing.
  Never use both in the same viewport.
- **Minimum size.** Mark: 24px. Below that the three valve buttons fill in and
  the horn turns into a blob — acceptable only as a favicon, not as UI.
  Full lockup: 120px wide, which is where the Sora wordmark stays legible.
- **Clear space.** Keep at least 12.5% of the mark's width (one eighth of the
  tile) free on all sides. Nothing else inside that box.
- **Dark mode.** Always pick the variant that matches the *surface behind it*,
  not the app theme. The mark carries its own tile, so it is safe on any
  background — but the dark variant reads better on slate/near-black.
- **Do not** recolour, rotate, add a gradient, outline, or drop shadow, and do
  not stretch the lockup. The wordmark is positioned for Sora 700; another
  face will reflow it.

## Fonts

`logo_full*.svg` reference **Sora 700** (the app's display face, used by
`AppTypography.displayLarge`/`headline*`) via an `@import` of Google Fonts.
That resolves in any browser. A vector editor without network access falls back
to a generic sans-serif and the wordmark width will differ — convert the text
to outlines before sending the file to print.

## Not included

- **Launcher icon.** The packaged mark is what goes in `mipmap-*/ic_launcher.png`
  (Android) and the iOS AppIcon set when you next cut a store build. Export at
  1024×1024 from `logo_mark.svg`. Not wired here because it is a native
  resource, not a Flutter one, and it only matters at release time.
- **Monochrome / favicon `.ico` / social avatar.** Add when a web or store
  listing actually needs them — the mark already works at 16px if you export it
  from `logo_mark.svg`.
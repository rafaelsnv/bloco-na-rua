# Bloco na Rua — Logo Alternatives

Recipes for cutting **alternative versions of the existing logo**. Not new brand
concepts — the same fanfarra horn + sunburst, recoloured, re-cropped or
re-exported at other sizes.

Read `assets/logo/README.md` first: it is the source of truth for the palette,
the usage rules and the fonts. This file only covers how to *derive* variants.

`assets/logo/alternatives/` does not exist yet. Create it the first time one of
these outputs is actually needed — do not scaffold it empty.

## Rules that never change

- **Never recolour outside the palette.** Every fill is an existing app token
  from `lib/ui/core/tokens/app_colors.dart`.
- **Never add gradients, shadows, strokes or outlines.** Flat fills only. The
  one exception is the tile-less mark, where the horn is *filled* in the ink
  colour instead of being outlined (see recipe 2).
- **Never stretch the lockup.** Scale proportionally; the wordmark is
  positioned for Sora 700 and reflows with any other face.
- **Always pick the variant that matches the surface behind the logo**, not the
  app theme.
- **Keep 12.5% clear space** (one eighth of the tile) free on all sides.
- **Minimum 24px for the mark.** Below that the valve buttons fill in and the
  horn turns into a blob — favicons only.
- **Minimum 120px wide for the full lockup.** That is where the Sora wordmark
  stays legible.

## Palette reference

Same tables as `README.md`, repeated here so this file is self-contained.

| Role | Light surface | Dark surface |
| --- | --- | --- |
| Tile / brand | `#7C3AED` (`AppColors.primary`) | `#A78BFA` (`AppColors.primaryLight`) |
| Horn | `#FFFFFF` (`AppColors.textOnPrimary`) | `#2E1065` (`AppColors.textOnPrimaryDark`) |
| Sunburst + valve buttons | `#FBBF24` (`AppColors.accentLight`) | `#D97706` (`AppColors.accent`) |
| Wordmark ink | `#1C1917` (`AppColors.textPrimary`) | `#FAFAF9` (`AppColors.textPrimaryDark`) |

## Source geometry

| File | viewBox | Notes |
| --- | --- | --- |
| `logo_mark.svg` | `0 0 64 64` | Rounded tile `<rect width="64" height="64" rx="18">`. Artwork group: `transform="translate(29.43 36.36) rotate(-35) scale(0.92)"`. |
| `logo_full.svg` | `0 0 208 80` | Mark at `translate(6 8)`, wordmark `<text x="86">` in Sora 700 at `font-size: 30px`. |

Both files carry the Google Fonts `@import` in a `<style>` block. Keep it in
anything that will be rendered by a browser.

## Re-export

Re-run this after editing any SVG in `assets/logo/`. The SVGs are the source;
the PNGs are derived.

```
inkscape assets/logo/logo_mark.svg --export-type=png \
  --export-filename=assets/logo/logo_mark.png --export-width=512
```

Every recipe below follows the same shape — copy the source SVG into
`assets/logo/alternatives/`, edit it there, export from the copy.

---

## 1. Monochrome / single-colour mark

One colour, one shape. Use it when the medium cannot hold more: embroidery,
single-colour print, vinyl cutting, embossing, laser engraving.

**Mandatory when:**

- **Embroidery or single-colour print** — a second thread colour is a second
  thread, and the tile is a solid blob at that point.
- **Favicons in the browser tab bar** — the tab bar forces its own background,
  so the mark must survive on an unknown colour.
- **Legal / official use** where the brand colour may not be reproduced.

**Recipe.**

1. Copy the source:

   ```
   Copy-Item assets/logo/logo_mark.svg assets/logo/alternatives/logo_mark_mono.svg
   ```

2. Replace **every** `fill` with a single value. In `logo_mark.svg` there are
   three: the tile `fill="#7C3AED"`, the sunburst group `fill="#FBBF24"`, and
   the horn path `fill="#FFFFFF"`. All three become the same colour:

   ```xml
   <rect width="64" height="64" rx="18" fill="#FFFFFF"/>
   <g fill="#FFFFFF">
   ...
   <path fill="#FFFFFF" d="M-25 -2.6 L-20 -5 ..."/>
   ```

3. Which colour, by surface:

   | Surface | Mono colour | Token |
   | --- | --- | --- |
   | Dark footer, slate, near-black | `#FFFFFF` | `AppColors.textOnPrimary` |
   | Print on white paper | `#7C3AED` | `AppColors.primary` |
   | Print on coloured stock | `#FFFFFF` | `AppColors.textOnPrimary` |

4. Export:

   ```
   inkscape assets/logo/alternatives/logo_mark_mono.svg --export-type=png \
     --export-filename=assets/logo/alternatives/logo_mark_mono.png --export-width=512
   ```

The tile stays — a monochrome mark still has a silhouette. For a tile-less
monochrome, do recipe 2 and skip the tile.

## 2. Tile-less (transparent background) mark

Same artwork, no `<rect>` tile, transparent behind it. Use on coloured
surfaces where the violet tile would clash — a violet banner, a photo, a
coloured app bar.

**What changes as a result:** the horn is `fill="#FFFFFF"`. On a white surface
it disappears completely. So on a transparent mark the horn is **filled with
the ink colour instead of white**, not outlined — flat fills only, per the
rules above.

**Recipe.**

1. Copy the source:

   ```
   Copy-Item assets/logo/logo_mark.svg assets/logo/alternatives/logo_mark_tileless.svg
   ```

2. Delete the tile line entirely:

   ```xml
   <!-- delete this -->
   <rect width="64" height="64" rx="18" fill="#7C3AED"/>
   ```

3. Recolour the horn to the ink colour for the surface it will sit on:

   | Surface behind | Horn fill | Token | Sunburst fill | Token |
   | --- | --- | --- | --- | --- |
   | Light (white, `#FAFAF9`) | `#1C1917` | `AppColors.textPrimary` | `#FBBF24` | `AppColors.accentLight` |
   | Dark (`#111827`, `#1F2937`) | `#FAFAF9` | `AppColors.textPrimaryDark` | `#D97706` | `AppColors.accent` |

   ```xml
   <!-- light surface -->
   <g fill="#FBBF24">
   ...
   <path fill="#1C1917" d="M-25 -2.6 L-20 -5 ..."/>
   ```

   ```xml
   <!-- dark surface -->
   <g fill="#D97706">
   ...
   <path fill="#FAFAF9" d="M-25 -2.6 L-20 -5 ..."/>
   ```

4. Export with transparency. `--export-background-opacity` keeps the alpha
   channel:

   ```
   inkscape assets/logo/alternatives/logo_mark_tileless.svg --export-type=png \
     --export-filename=assets/logo/alternatives/logo_mark_tileless.png \
     --export-width=512 --export-background-opacity=0
   ```

5. Pick the variant that matches the surface *behind the logo*, not the app
   theme. A tile-less mark on the wrong surface is invisible.

## 3. Favicon / `.ico`

**Inkscape cannot write `.ico`.** Inkscape's export formats cover PNG, PDF, PS,
EPS and SVG — there is no `.ico` writer. Export the PNGs from Inkscape and
pack them with ImageMagick, which does the multi-size `.ico` in one step.

**Recipe.**

1. Export the three sizes from `logo_mark.svg` (use the light variant — the
   favicon sits on a browser tab bar, usually light):

   ```
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=assets/logo/alternatives/favicon-16.png --export-width=16
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=assets/logo/alternatives/favicon-32.png --export-width=32
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=assets/logo/alternatives/favicon-48.png --export-width=48
   ```

2. Pack them into a multi-size `.ico` with ImageMagick:

   ```
   magick assets/logo/alternatives/favicon-16.png \
           assets/logo/alternatives/favicon-32.png \
           assets/logo/alternatives/favicon-48.png \
           assets/logo/alternatives/favicon.ico
   ```

3. Fallback if ImageMagick is not available — Python + Pillow:

   ```
   python -c "from PIL import Image; Image.open('assets/logo/alternatives/favicon-16.png').save('assets/logo/alternatives/favicon.ico', sizes=[(16,16),(32,32),(48,48)])"
   ```

4. Ship an SVG favicon too — it is the sharpest at any DPR and it is one line
   of markup:

   ```
   Copy-Item assets/logo/logo_mark.svg assets/logo/alternatives/favicon.svg
   ```

   ```html
   <link rel="icon" href="/favicon.svg" type="image/svg+xml">
   <link rel="alternate icon" href="/favicon.ico" sizes="48x48">
   ```

Below 24px the valve buttons fill in and the horn turns into a blob. That is
acceptable for a favicon and for nothing else.

## 4. Launcher / app icon

Native resource, not a Flutter one. Cut it when a store build is next.

**Recipe.**

1. Export the 1024×1024 source from `logo_mark.svg`:

   ```
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=assets/logo/alternatives/ic_launcher_1024.png --export-width=1024
   ```

2. Android — `mipmap-*/ic_launcher.png`, five densities:

   | Density | Size | Folder |
   | --- | --- | --- |
   | mdpi | 48×48 | `android/app/src/main/res/mipmap-mdpi/` |
   | hdpi | 72×72 | `android/app/src/main/res/mipmap-hdpi/` |
   | xhdpi | 96×96 | `android/app/src/main/res/mipmap-xhdpi/` |
   | xxhdpi | 144×144 | `android/app/src/main/res/mipmap-xxhdpi/` |
   | xxxhdpi | 192×192 | `android/app/src/main/res/mipmap-xxxhdpi/` |

   Export each from the 1024 source:

   ```
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=android/app/src/main/res/mipmap-mdpi/ic_launcher.png --export-width=48
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=android/app/src/main/res/mipmap-hdpi/ic_launcher.png --export-width=72
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=android/app/src/main/res/mipmap-xhdpi/ic_launcher.png --export-width=96
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png --export-width=144
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png --export-width=192
   ```

3. iOS — the Xcode asset catalog expects a **single 1024×1024 source** for the
   App Store slot; Xcode scales the rest. Drop the 1024 PNG as
   `AppIcon.appiconset/icon-1024.png` and reference it in `Contents.json`:

   ```json
   {
     "images": [
       { "filename": "icon-1024.png", "idiom": "universal", "platform": "ios", "size": "1024x1024" }
     ],
     "info": { "author": "xcode", "version": 1 }
   }
   ```

   The iOS App Store slot requires **no transparency** and **no alpha channel**.
   Export with an opaque background:

   ```
   inkscape assets/logo/logo_mark.svg --export-type=png \
     --export-filename=ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png \
     --export-width=1024 --export-background="#7C3AED" --export-background-opacity=1
   ```

4. **Adaptive icon warning.** Android's adaptive icon masks the artwork to a
   circle of the inner 80% and can crop to a squircle, blob or full square. The
   current artwork group is `scale(0.92)` inside the 64×64 tile and its horns
   and sunburst rays reach slightly past that inner circle — they get clipped.

   If you ship an adaptive icon, scale the mark group down from `0.92` to
   about `0.85`:

   ```xml
   <g transform="translate(29.43 36.36) rotate(-35) scale(0.85)">
   ```

   Then export the foreground layer at the adaptive sizes (108dp canvas, 72dp
   safe zone) as `ic_launcher_foreground.png`, with the flat `#7C3AED` tile as
   `ic_launcher_background.png`.

## 5. Social avatar / Open Graph image

Built from `logo_full.svg` on a solid brand-violet field. This is the only
recipe that adds a background — the field is a flat `AppColors.primary`
`#7C3AED`, not a gradient.

**Recipe — OG image, 1200×630.**

1. Write a wrapper SVG that embeds the full lockup on the violet field. The
   wordmark must be recoloured for a violet ground: `Bloco` in `#FFFFFF` and
   `na Rua` in `#FAFAF9`, otherwise `#7C3AED` on `#7C3AED` is invisible.

   ```xml
   <svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
     <rect width="1200" height="630" fill="#7C3AED"/>
     <g transform="translate(496 275)">
       <image href="logo_full.svg" width="208" height="80"/>
     </g>
   </svg>
   ```

   Replace the `<image href>` with an inline copy of the lockup if the renderer
   will not resolve external references, and set the two `<text>` fills to
   `#FFFFFF` / `#FAFAF9`.

2. Export:

   ```
   inkscape assets/logo/alternatives/og-1200x630.svg --export-type=png \
     --export-filename=assets/logo/alternatives/og-1200x630.png --export-width=1200
   ```

**Recipe — avatar, 400×400.**

Same field, mark centred:

```
inkscape assets/logo/alternatives/avatar-400x400.svg --export-type=png \
  --export-filename=assets/logo/alternatives/avatar-400x400.png --export-width=400
```

The mark alone at 400px is legible and on-brand; the full lockup at 400px is
too small to read. Use the mark.

## 6. Wordmark-only and stacked lockups

The wordmark is Sora 700, 30px, on two lines at `x=86` in the 208×80 lockup.
It is set as live `<text>` with an `@import` of Google Fonts.

**The `@import` must be preserved for browser rendering.** Delete it and the
browser falls back to a generic sans-serif and the wordmark reflows. Convert
to outlines only for print (recipe 7).

**Recipe — wordmark only.**

1. Copy `logo_full.svg` to `assets/logo/alternatives/logo_wordmark.svg`.
2. Delete the whole `<g transform="translate(6 8)">` block — the mark and its
   tile.
3. Reset the viewBox so the text is not clipped: `viewBox="70 0 138 80"`,
   `width="138" height="80"`.

**Recipe — stacked lockup** (mark on top, wordmark below).

Change the viewBox to `0 0 208 132`, keep the mark at `translate(72 8)`, and
move the two `<text>` lines to `x="104"` with `text-anchor="middle"` at
`y="96"` and `y="124"`:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 208 132" width="208" height="132" role="img" aria-label="Bloco na Rua">
  ...
  <g transform="translate(72 8)">
    <rect width="64" height="64" rx="18" fill="#7C3AED"/>
    ...
  </g>
  <text class="w" x="104" y="96" text-anchor="middle" fill="#7C3AED">Bloco</text>
  <text class="w" x="104" y="124" text-anchor="middle" fill="#1C1917">na Rua</text>
</svg>
```

**Minimum widths, where the lockup stays legible:**

| Variant | Minimum width | Below that |
| --- | --- | --- |
| Mark | 24px | Valve buttons fill in, horn becomes a blob. Favicon only. |
| Full lockup | 120px | Sora 700 stops being readable. |
| Stacked lockup | 96px | Same — the two-line wordmark needs the height. |
| Wordmark only | 80px | Strokes of Sora 700 get too thin. |

## 7. Print / PDF prep

For anything that goes to a printer, the web-imported font must become
outlines, or the printer's RIP substitutes a different face.

**Recipe.**

1. Make sure **Sora 700** is installed locally. The `@import` of Google Fonts
   resolves in a browser; it does not resolve in a vector editor without
   network access, and it never resolves in a PDF at the printer.

2. Open the SVG in Inkscape and convert the text to paths:

   ```
   Path > Object to Path
   ```

   or `Shift+Ctrl+C` with the `<text>` selected. The `<text>` becomes a
   `<path>`; the `@import` in `<style>` can then be dropped.

3. Export to PDF:

   ```
   inkscape assets/logo/alternatives/logo_full_outlined.svg --export-type=pdf \
     --export-filename=assets/logo/alternatives/logo_full.pdf \
     --export-text-to-path
   ```

4. Check the PDF before sending it: open it, confirm the wordmark is a filled
   outline and not selectable text, and confirm no colour got swapped.

For a printer that wants CMYK, convert the flat fills in the vector editor
after outlining the text — never after rasterising.

---

## Outputs and target filenames

`assets/logo/alternatives/` does not exist yet. Create it with the first
alternative that is actually needed, and drop the files in as they are cut.

| Output | Target filename | Recipe |
| --- | --- | --- |
| Monochrome mark, SVG | `assets/logo/alternatives/logo_mark_mono.svg` | 1 |
| Monochrome mark, PNG 512 | `assets/logo/alternatives/logo_mark_mono.png` | 1 |
| Tile-less mark, SVG | `assets/logo/alternatives/logo_mark_tileless.svg` | 2 |
| Tile-less mark, PNG 512 | `assets/logo/alternatives/logo_mark_tileless.png` | 2 |
| Favicon PNG 16 / 32 / 48 | `assets/logo/alternatives/favicon-16.png`, `favicon-32.png`, `favicon-48.png` | 3 |
| Favicon multi-size `.ico` | `assets/logo/alternatives/favicon.ico` | 3 |
| Favicon SVG | `assets/logo/alternatives/favicon.svg` | 3 |
| Launcher source 1024 | `assets/logo/alternatives/ic_launcher_1024.png` | 4 |
| Android `mipmap-*/ic_launcher.png` | `android/app/src/main/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png` | 4 |
| iOS AppIcon source | `ios/Runner/Assets.xcassets/AppIcon.appiconset/icon-1024.png` | 4 |
| OG image 1200×630 | `assets/logo/alternatives/og-1200x630.png` | 5 |
| Social avatar 400×400 | `assets/logo/alternatives/avatar-400x400.png` | 5 |
| Wordmark only | `assets/logo/alternatives/logo_wordmark.svg` | 6 |
| Stacked lockup | `assets/logo/alternatives/logo_stacked.svg` | 6 |
| Outlined lockup + print PDF | `assets/logo/alternatives/logo_full_outlined.svg`, `logo_full.pdf` | 7 |

Nothing in this table is generated by default. Cut a variant when a real
surface needs it, and add the row then.

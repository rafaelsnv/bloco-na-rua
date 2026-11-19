# Bloco na Rua — Brand & Logo Guide

Bloco na Rua is an organiser for Brazilian **fanfarra** — the brass bands that
march as *blocos de rua* in the carnival street circuit. The app schedules
rehearsals, marches and gigs for the musicians in the band.

The logo is a **fanfarra horn** (brass fanfare trumpet) firing a **gold
sunburst**, on a rounded violet tile. Every colour is drawn from the app's own
palette — nothing was invented for the logo.

This guide is self-contained: palette, usage rules, fonts, source geometry,
variant recipes, new logo concepts and the build checklist all live here.

---

## The logo

### File inventory

| File | What it is | Use it for |
| --- | --- | --- |
| `logo_mark.svg` | Symbol only, 64×64 viewBox | Light surfaces. Source of truth. |
| `logo_mark_dark.svg` | Same artwork, dark-surface colours | Dark surfaces (`#111827`, `#1F2937`). |
| `logo_full.svg` | Mark + wordmark "Bloco na Rua", 208×80 | Headers, splash, docs, marketing. Light surfaces. |
| `logo_full_dark.svg` | Same lockup, dark-surface colours | Dark surfaces. |
| `logo_mark.png` | 512×512 raster of `logo_mark` | **What the app loads.** |
| `logo_mark_dark.png` | 512×512 raster of `logo_mark_dark` | **What the app loads in dark mode.** |
| `preview.svg` / `preview.png` | Both variants side by side on `#FAFAF9` and `#111827`, at 40/32/24px | Review only. |

### Source vs derived

The SVGs are the source; the PNGs are derived. Re-export after editing any SVG:

```
inkscape logo_mark.svg --export-type=png \
  --export-filename=logo_mark.png --export-width=512
```

Every derivation recipe below follows the same shape — copy the source SVG into
the working folder, edit it there, export from the copy.

---

## Palette

Every colour is taken from the product's design tokens — the logo introduces no
new colour. The dark variant mirrors the product's own light/dark theme
inversion: the light theme is a violet tile with a white horn, the dark theme is
a light-violet tile with a dark-violet horn.

| Role | Light surface | Dark surface |
| --- | --- | --- |
| Tile / brand | `#7C3AED` | `#A78BFA` |
| Horn / main shape | `#FFFFFF` | `#2E1065` |
| Sunburst + valve buttons / energy | `#FBBF24` | `#D97706` |
| "na Rua" wordmark ink | `#1C1917` | `#FAFAF9` |

Two brand colours plus one accent (gold = carnival energy). No gradients, no
shadows — same flat language as the rest of the UI.

---

## Usage rules

- **Mark vs full.** Use `logo_mark` anywhere the product name is already
  present (app bars, list headers, avatars, the bottom nav). Use `logo_full`
  only for standalone moments: splash screen, README header, store listing.
  Never use both in the same viewport.
- **Minimum size.** Mark: 24px. Below that the three valve buttons fill in and
  the horn turns into a blob — acceptable only as a favicon, not as UI.
  Full lockup: 120px wide, which is where the Sora wordmark stays legible.
  Stacked lockup: 96px. Wordmark only: 80px.
- **Clear space.** Keep at least 12.5% of the mark's width (one eighth of the
  tile) free on all sides. Nothing else inside that box.
- **Dark mode.** Always pick the variant that matches the *surface behind it*,
  not the app theme. The mark carries its own tile, so it is safe on any
  background — but the dark variant reads better on slate/near-black.
- **Do not** recolour, rotate, add a gradient, outline, or drop shadow, and do
  not stretch the lockup. The wordmark is positioned for Sora 700; another
  face will reflow it.

| Variant | Minimum width | Below that |
| --- | --- | --- |
| Mark | 24px | Valve buttons fill in, horn becomes a blob. Favicon only. |
| Full lockup | 120px | Sora 700 stops being readable. |
| Stacked lockup | 96px | Same — the two-line wordmark needs the height. |
| Wordmark only | 80px | Strokes of Sora 700 get too thin. |

---

## Fonts

`logo_full*.svg` reference **Sora 700** (the app's display face) via an
`@import` of Google Fonts:

```
@import url('https://fonts.googleapis.com/css2?family=Sora:wght@700&display=swap');
```

That resolves in any browser. A vector editor without network access falls back
to a generic sans-serif and the wordmark width will differ — convert the text
to outlines before sending the file to print. The `@import` must be preserved
for browser rendering; delete it and the browser falls back to a generic
sans-serif and the wordmark reflows.

---

## Source geometry

| File | viewBox | Notes |
| --- | --- | --- |
| `logo_mark.svg` | `0 0 64 64` | Rounded tile `<rect width="64" height="64" rx="18">`. Artwork group: `transform="translate(29.43 36.36) rotate(-35) scale(0.92)"`. |
| `logo_full.svg` | `0 0 208 80` | Mark at `translate(6 8)`, wordmark `<text x="86">` in Sora 700 at `font-size: 30px`. |

Both files carry the Google Fonts `@import` in a `<style>` block. Keep it in
anything that will be rendered by a browser.

The mark's artwork is a gold sunburst group (`fill="#FBBF24"` — five rays plus
three valve buttons) and a white horn path (`fill="#FFFFFF"`).

---

## Deriving variants — 7 recipes

Run every command below from the folder that holds the logo files.

These are recipes for cutting **alternative versions of the existing logo** —
the same fanfarra horn + sunburst, recoloured, re-cropped or re-exported at
other sizes. They are not new brand concepts.

`alternatives/` does not exist yet. Create it the first time one of
these outputs is actually needed — do not scaffold it empty.

### Rules that never change

- **Never recolour outside the palette.** Every fill is an existing product
  design token — the logo introduces no new colour.
- **Never add gradients, shadows, strokes or outlines.** Flat fills only. The
  one exception is the tile-less mark, where the horn is *filled* in the ink
  colour instead of being outlined.
- **Never stretch the lockup.** Scale proportionally; the wordmark is
  positioned for Sora 700 and reflows with any other face.
- **Always pick the variant that matches the surface behind the logo**, not the
  app theme.
- **Keep 12.5% clear space** (one eighth of the tile) free on all sides.
- **Minimum 24px for the mark.** Below that the valve buttons fill in and the
  horn turns into a blob — favicons only.
- **Minimum 120px wide for the full lockup.** That is where the Sora wordmark
  stays legible.

### Recipe 1 — Monochrome / single-colour mark

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
   Copy-Item logo_mark.svg alternatives/logo_mark_mono.svg
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

   | Surface | Mono colour |
   | --- | --- |
   | Dark footer, slate, near-black | `#FFFFFF` |
   | Print on white paper | `#7C3AED` |
   | Print on coloured stock | `#FFFFFF` |

4. Export:

   ```
   inkscape alternatives/logo_mark_mono.svg --export-type=png \
     --export-filename=alternatives/logo_mark_mono.png --export-width=512
   ```

The tile stays — a monochrome mark still has a silhouette. For a tile-less
monochrome, follow recipe 2 and skip the tile.

### Recipe 2 — Tile-less (transparent background) mark

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
   Copy-Item logo_mark.svg alternatives/logo_mark_tileless.svg
   ```

2. Delete the tile line entirely:

   ```xml
   <!-- delete this -->
   <rect width="64" height="64" rx="18" fill="#7C3AED"/>
   ```

3. Recolour the horn to the ink colour for the surface it will sit on:

   | Surface behind | Horn fill | Sunburst fill |
   | --- | --- | --- |
   | Light (white, `#FAFAF9`) | `#1C1917` | `#FBBF24` |
   | Dark (`#111827`, `#1F2937`) | `#FAFAF9` | `#D97706` |

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
   inkscape alternatives/logo_mark_tileless.svg --export-type=png \
     --export-filename=alternatives/logo_mark_tileless.png \
     --export-width=512 --export-background-opacity=0
   ```

5. Pick the variant that matches the surface *behind the logo*, not the app
   theme. A tile-less mark on the wrong surface is invisible.

### Recipe 3 — Favicon / `.ico`

**Inkscape cannot write `.ico`.** Inkscape's export formats cover PNG, PDF, PS,
EPS and SVG — there is no `.ico` writer. Export the PNGs from Inkscape and
pack them with ImageMagick, which does the multi-size `.ico` in one step.

**Recipe.**

1. Export the three sizes from `logo_mark.svg` (use the light variant — the
   favicon sits on a browser tab bar, usually light):

   ```
   inkscape logo_mark.svg --export-type=png \
     --export-filename=alternatives/favicon-16.png --export-width=16
   inkscape logo_mark.svg --export-type=png \
     --export-filename=alternatives/favicon-32.png --export-width=32
   inkscape logo_mark.svg --export-type=png \
     --export-filename=alternatives/favicon-48.png --export-width=48
   ```

2. Pack them into a multi-size `.ico` with ImageMagick:

   ```
   magick alternatives/favicon-16.png \
           alternatives/favicon-32.png \
           alternatives/favicon-48.png \
           alternatives/favicon.ico
   ```

3. Fallback if ImageMagick is not available — Python + Pillow:

   ```
   python -c "from PIL import Image; Image.open('alternatives/favicon-16.png').save('alternatives/favicon.ico', sizes=[(16,16),(32,32),(48,48)])"
   ```

4. Ship an SVG favicon too — it is the sharpest at any DPR and it is one line
   of markup:

   ```
   Copy-Item logo_mark.svg alternatives/favicon.svg
   ```

   ```html
   <link rel="icon" href="/favicon.svg" type="image/svg+xml">
   <link rel="alternate icon" href="/favicon.ico" sizes="48x48">
   ```

Below 24px the valve buttons fill in and the horn turns into a blob. That is
acceptable for a favicon and for nothing else.

### Recipe 4 — Launcher / app icon

Native resource, not an app asset. Cut it when a store build is next.

**Recipe.**

1. Export the 1024×1024 source from `logo_mark.svg`:

   ```
   inkscape logo_mark.svg --export-type=png \
     --export-filename=alternatives/ic_launcher_1024.png --export-width=1024
   ```

2. Android — `mipmap-*/ic_launcher.png`, five densities:

   | Density | Size | Folder |
   | --- | --- | --- |
   | mdpi | 48×48 | `mipmap-mdpi/` |
   | hdpi | 72×72 | `mipmap-hdpi/` |
   | xhdpi | 96×96 | `mipmap-xhdpi/` |
   | xxhdpi | 144×144 | `mipmap-xxhdpi/` |
   | xxxhdpi | 192×192 | `mipmap-xxxhdpi/` |

   Export each from the 1024 source:

   ```
   inkscape logo_mark.svg --export-type=png \
     --export-filename=mipmap-mdpi/ic_launcher.png --export-width=48
   inkscape logo_mark.svg --export-type=png \
     --export-filename=mipmap-hdpi/ic_launcher.png --export-width=72
   inkscape logo_mark.svg --export-type=png \
     --export-filename=mipmap-xhdpi/ic_launcher.png --export-width=96
   inkscape logo_mark.svg --export-type=png \
     --export-filename=mipmap-xxhdpi/ic_launcher.png --export-width=144
   inkscape logo_mark.svg --export-type=png \
     --export-filename=mipmap-xxxhdpi/ic_launcher.png --export-width=192
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
   inkscape logo_mark.svg --export-type=png \
     --export-filename=AppIcon.appiconset/icon-1024.png \
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

### Recipe 5 — Social avatar / Open Graph image

Built from `logo_full.svg` on a solid brand-violet field. This is the only
recipe that adds a background — the field is a flat brand violet
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
   inkscape alternatives/og-1200x630.svg --export-type=png \
     --export-filename=alternatives/og-1200x630.png --export-width=1200
   ```

**Recipe — avatar, 400×400.**

Same field, mark centred:

```
inkscape alternatives/avatar-400x400.svg --export-type=png \
  --export-filename=alternatives/avatar-400x400.png --export-width=400
```

The mark alone at 400px is legible and on-brand; the full lockup at 400px is
too small to read. Use the mark.

### Recipe 6 — Wordmark-only and stacked lockups

The wordmark is Sora 700, 30px, on two lines at `x=86` in the 208×80 lockup.
It is set as live `<text>` with an `@import` of Google Fonts.

**The `@import` must be preserved for browser rendering.** Delete it and the
browser falls back to a generic sans-serif and the wordmark reflows. Convert
to outlines only for print.

**Recipe — wordmark only.**

1. Copy `logo_full.svg` to `alternatives/logo_wordmark.svg`.
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

Minimum widths are listed in the usage rules table: mark 24px, full lockup
120px, stacked lockup 96px, wordmark only 80px.

### Recipe 7 — Print / PDF prep

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
   inkscape alternatives/logo_full_outlined.svg --export-type=pdf \
     --export-filename=alternatives/logo_full.pdf \
     --export-text-to-path
   ```

4. Check the PDF before sending it: open it, confirm the wordmark is a filled
   outline and not selectable text, and confirm no colour got swapped.

For a printer that wants CMYK, convert the flat fills in the vector editor
after outlining the text — never after rasterising.

---

## New logo concepts

Three **new** brand ideas for the app. Not recolours of the incumbent fanfarra
horn + sunburst.

**The artwork does not exist yet.** This section is the spec a designer or an
implementer builds from. Nothing here is cut.

`concept_*/` folders **do not exist**. Create a folder only when a
concept is actually built — do not scaffold them empty.

### Shared rules

These do not change per concept. Reuse them verbatim, do not invent new ones.

- **Same palette only.** Every fill is an existing product design token. The
  logo introduces no new colour.
- **Flat fills only.** No gradients, no shadows, no strokes, no outlines.
- **Mark canvas.** `viewBox="0 0 64 64"` for a mark. If a tile is used, it is
  `<rect width="64" height="64" rx="18">` — the same tile as the incumbent.
- **Clear space.** Keep at least 12.5% of the mark's width (one eighth of the
  tile) free on all sides. Nothing else inside that box.
- **Minimum size.** Mark: 24px. Below that the internal detail fills in and the
  shape turns into a blob — acceptable only as a favicon, not as UI. Full
  lockup: 120px wide.
- **Wordmark.** Sora 700 (the app's display face) via an `@import` of Google
  Fonts, in the 208×80 lockup at `x=86`, `font-size: 30px`.
- **Never stretch the lockup**, never recolour outside the palette, never add
  a gradient, outline or drop shadow.
- **Pick the variant that matches the surface behind the logo**, not the app
  theme.
- **Export.** Inkscape, at 512. The SVGs are the source; the PNGs are derived.

The four roles are the same as the incumbent, so all three concepts are
colour-compatible with the existing lockup: tile `#7C3AED` / `#A78BFA`, main
shape `#FFFFFF` / `#2E1065`, energy `#FBBF24` / `#D97706`, ink `#1C1917` /
`#FAFAF9`.

### Concept A — "Repineta" (street drum)

**Idea + inspiration.**

The repineta is the drum every bloco carries on the street — a small snare that
sets the tempo the whole fanfarra follows. The concept is the drum mid-march:
a body being struck, with motion and rhythm marks trailing behind it. It
replaces the incumbent's static "instrument playing" idea with the app's
actual subject: a bloco **moving through the street**.

**Composition.**

- **Dominant shape.** A drum body seen slightly from above — an ellipse tilted
  `-12°`, roughly 34 units wide and 22 units tall, centred at about
  `(30 34)`. Below it a shallow shell body (a rounded trapezoid, `rx=4`,
  height 14) with a single gold rim band across the bottom.
- **Secondary shapes.** A drumstick above the ellipse, angled `-55°`, running
  from `(20 18)` to `(38 30)`. Three **rhythm chevrons** (`>`, 8 units wide,
  3 units thick, `-12°` tilt) trail off the upper-left of the shell at
  `(14 30)`, `(16 38)`, `(18 46)`, stepping down-left — the zig-zag beat of a
  repique.
- **Negative space.** The gap between the drumstick and the ellipse, and the
  open band between the gold rim and the shell bottom. Keep the shell's inner
  ring unfilled: the ellipse reads as a hollow drum head because the drum body
  below it is a separate solid mass.
- **Silhouette at 32px.** A tilted oval sitting on a trapezoid, with a diagonal
  stick crossing the top-left corner and three chevrons on the left. Reads as
  "drum + motion" as long as the chevrons stay at least 3 units thick and the
  stick is at least 3 units wide.

**Colour mapping.**

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Drum shell + drumstick | `#FFFFFF` | `#2E1065` |
| Rim band + rhythm chevrons | `#FBBF24` | `#D97706` |

**Strengths / weaknesses.**

| | |
| --- | --- |
| **Small-size legibility** | Strong. Two masses (oval + trapezoid) plus a stick; nothing is thinner than 3 units. Survives at 24px better than a horn. |
| **Distinctiveness vs incumbent** | High. The incumbent is brass + burst; this is a drum + chevrons. No shared silhouette. |
| **Cost to draw** | Low. Two ellipses, one trapezoid, one stick, three chevrons — no curves to tune beyond the drum head. |
| **Monochrome** | Good. The shell and stick merge into one white mass, but the chevrons still separate the left edge. Keep the chevrons at full length in mono. |
| **Weakness** | A drum is a generic percussion symbol — less specific to *fanfarra* than a horn. Needs the chevrons to carry the "street march" idea. |

**Best used for.**

Login header, onboarding, app bar, favicon, print. The chevrons give it
directional energy that works well in a horizontal lockup, and the drum reads
cleanly at 24px for a bottom-nav icon.

### Concept B — "Saxofone"

**Idea + inspiration.**

A saxophone in profile — the instrument that carries the melody over the
battery's noise. The concept is the sax mid-solo, its notes flying out of the
bell and arranging themselves into the banner/flag a bloco carries at the
front of the march. It pairs the app's two real subjects: the sound and the
street procession.

**Composition.**

- **Dominant shape.** A saxophone in profile, standing roughly vertical, body
  spanning `(20 14)` to `(40 52)`. The bell flares at the top-left
  (`rotate(-20°)` about `(24 16)`), the tube runs down and curves right at
  the bottom into a small upturned bell at `(40 50)`. A single key-cluster
  notch on the upper right of the tube.
- **Secondary shapes.** A **flag/banner** shape in the upper-right: a
  swallow-tail pennant on a short diagonal staff running from `(38 18)` up
  to `(46 10)`, the pennant spanning `(46 10)`–`(58 20)` with a `V` notch in
  the outer edge. Three **note marks** (small circles of 2.5 units radius plus
  a short stem) rise between the sax bell and the pennant at `(28 10)`,
  `(34 8)`, `(39 12)`.
- **Negative space.** The open curve between the sax body and the bell flare —
  a crescent of tile colour on the upper left. It is the main visual break
  that keeps the mark from reading as a blob.
- **Silhouette at 32px.** A tall curving instrument with a flared top, a
  pennant flag in the upper right and three dots above. Distinctive at a
  glance, but the smallest note marks must be dropped below 32px.

**Colour mapping.**

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Sax body + staff | `#FFFFFF` | `#2E1065` |
| Pennant + note marks | `#FBBF24` | `#D97706` |

**Strengths / weaknesses.**

| | |
| --- | --- |
| **Small-size legibility** | Weakest of the three. The curved tube and three separate note marks fill in fast; the pennant notch closes up. Needs a 32px floor rather than 24px. |
| **Distinctiveness vs incumbent** | Medium-high. A sax is a different instrument family and a different shape language, but it is still "one instrument with rays off it" — the burst becomes a flag. |
| **Cost to draw** | Highest. A convincing sax profile needs real bezier work and careful tuning; the flag and staff add more. |
| **Monochrome** | Mediocre. The tube and staff cross, so a single fill merges them. Needs the tile knocked out between the staff and the pennant to survive. |
| **Weakness** | The busiest composition. Notes + flag + instrument = three competing focal points, and the pennant can be mistaken for a separate logo element. |

**Best used for.**

Onboarding and marketing illustrations, the login header at large size, print.
Not recommended for the app bar, the bottom nav or a favicon — too much detail
for those.

### Concept C — "Escudo da Fanfarra" (marching-band crest)

**Idea + inspiration.**

A badge, the way a marching band or a school of samba carries a crest. The
concept is a shield assembled from the fanfarra's own objects: horn
silhouettes, carnival feathers, and a ribbon banner across the bottom that
carries the name. It is the most "heraldic" of the three and the most
obviously Brazilian-carnival in reference.

**Composition.**

- **Dominant shape.** A shield, `viewBox` centred, spanning `(10 8)` to
  `(54 40)`, with straight sides, a slight point at the bottom centre, and a
  `rx=3` top edge. Drawn as a single filled path.
- **Secondary shapes.** Two **horn silhouettes** mirrored left and right
  inside the upper shield, bells pointing outward-up, each about 16 units
  long, meeting near the centre. Three **carnival feathers** (leaf-shaped
  paths, tapered, 20 units long) fanning from behind the shield's top centre
  at `-25°`, `0°`, `+25°`. A **ribbon banner** across the bottom at
  `y=40`–`52`, wider than the shield's point, with forked tails at
  `(8 44)` and `(56 44)`.
- **Negative space.** The ribbon cuts a horizontal band across the shield's
  bottom point, so the shield reads as an upper field plus a ribbon rather than
  one solid blob. The space between the two mirrored horns holds the centre.
- **Silhouette at 32px.** A shield with a ribbon under it, feathers on top.
  Reads as "crest" or "badge" immediately. The individual horns disappear —
  they are interior detail, not silhouette.

**Colour mapping.**

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Shield outline / shield body | `#FFFFFF` | `#2E1065` |
| Horns, feathers, ribbon | `#FBBF24` | `#D97706` |

**Strengths / weaknesses.**

| | |
| --- | --- |
| **Small-size legibility** | Good at the silhouette level, poor in the interior. At 24px the horns and feathers turn into texture; the shield + ribbon still reads. |
| **Distinctiveness vs incumbent** | Low-medium. The horns inside the shield are the same motif as the incumbent — horn plus gold energy — just framed. |
| **Cost to draw** | Highest. Shield path, two mirrored horns, three feathers, ribbon with forked tails: four distinct sub-shapes. |
| **Monochrome** | Good. A shield silhouette plus a ribbon silhouette is enough; drop the interior horns and keep the shield. |
| **Weakness** | The most conventional of the three, and the closest to the incumbent. It reads as "marching band", which is the app's world, but it does not change the brand's central idea. |

**Best used for.**

Print, merchandise, the store listing, and as a full lockup with the ribbon
carrying the wordmark. As a 24px app icon the interior is wasted space.

---

## Comparison

| | A — Repineta | B — Saxofone | C — Escudo |
| --- | --- | --- | --- |
| **Distinctiveness** | High | Medium-high | Low-medium |
| **Small-size legibility** | Strong (24px) | Weak (32px floor) | Good at silhouette, weak in detail |
| **Distinctness from incumbent** | High | Medium-high | Low — reuses the horn motif |
| **Implementation cost** | Low | High | High |
| **Recommended surface** | App bar, bottom nav, favicon, login header | Onboarding, marketing, large print | Print, merchandise, store listing |

---

## Recommendation

**Build A — "Repineta" first.**

Reasons, in order:

1. It is the only concept that carries a new *idea*, not a new instrument. A
   drum mid-march with rhythm chevrons says "a bloco moving through the
   street" — which is what the app is about. B says "a saxophone", C says "a
   marching band".
2. It is the cheapest to draw and the most robust: two solid masses and four
   simple strokes, everything ≥3 units thick. That is what survives the 24px
   minimum.
3. It stays clearly distinct from the incumbent, so the brand can pivot
   without losing recognition.
4. The chevrons give it horizontal energy, which is exactly what a 208×80
   lockup next to a wordmark needs.

**Conditions that change the answer:**

- **If the mark must work as a monochrome stamp on merchandise** (single-colour
  embroidery, vinyl, engraving) — pick **A** anyway, but the chevrons must
  survive in one colour. If they do not, pick **C** and ship the shield
  silhouette alone.
- **If the brand must stay explicitly "fanfarra"** — pick **C**. It is the only
  one that keeps the brass instrument inside the mark.
- **If the mark is mostly used large** (onboarding carousel, splash, print) and
  the app bar icon is not a priority — pick **B**. The saxophone is the most
  expressive of the three at large size.
- **If a store icon must double as the app icon on Android** — prefer **A**.
  Its silhouette sits inside the adaptive icon's inner circle far more
  comfortably than the shield's feathers.

---

## Build checklist

Take the chosen concept and produce these four files. The SVGs are the
source; the PNGs are derived.

| File | What it is |
| --- | --- |
| `concept_<slug>/logo_mark.svg` | Mark, light surface. `viewBox="0 0 64 64"`. Source of truth. |
| `concept_<slug>/logo_mark_dark.svg` | Same artwork, dark-surface colours. |
| `concept_<slug>/logo_mark.png` | 512×512 raster of `logo_mark`. |
| `concept_<slug>/logo_mark_dark.png` | 512×512 raster of `logo_mark_dark`. |

`<slug>` is the concept's short name: `repineta`, `saxofone`, `escudo`.

Steps:

1. **Create the folder** — only for the concept actually being built.

   ```
   New-Item -ItemType Directory concept_repineta
   ```

2. **Copy the incumbent mark** as the starting point, to inherit the tile, the
   viewBox and the `<title>`/`<desc>` structure:

   ```
   Copy-Item logo_mark.svg concept_repineta/logo_mark.svg
   Copy-Item logo_mark.svg concept_repineta/logo_mark_dark.svg
   ```

3. **Replace the artwork group** with the concept's geometry from its brief.
   Keep the `<rect width="64" height="64" rx="18">` tile as the first child and
   put the new artwork in a single `<g>` after it. Drop the incumbent's
   `transform="translate(29.43 36.36) rotate(-35) scale(0.92)"` — the
   coordinates in the briefs are already in the 64×64 space.

4. **Apply the colour mapping** table for the variant. Light surface: tile
   `#7C3AED`, main `#FFFFFF`, energy `#FBBF24`. Dark surface: tile `#A78BFA`,
   main `#2E1065`, energy `#D97706`.

5. **Update `<title>` and `<desc>`** in both SVGs to describe the new mark and
   the surface it is for.

6. **Export the PNGs** with Inkscape, at 512:

   ```
   inkscape concept_repineta/logo_mark.svg --export-type=png \
     --export-filename=concept_repineta/logo_mark.png --export-width=512
   inkscape concept_repineta/logo_mark_dark.svg --export-type=png \
     --export-filename=concept_repineta/logo_mark_dark.png --export-width=512
   ```

7. **Review at 40 / 32 / 24px** on both `#FAFAF9` and `#111827`. Anything that
   fills in below 24px is a favicon-only detail.

8. **If the concept is adopted**, cut the lockup too — `logo_full.svg` /
   `logo_full_dark.svg`, 208×80 viewBox, mark at `translate(6 8)`, wordmark
   `<text x="86">` in Sora 700 at `font-size: 30px`, `Bloco` in the brand
   colour and `na Rua` in the ink colour. Then apply the launcher icon,
   favicon, OG image and print prep recipes above.

The SVGs are the source; the PNGs are derived. Re-run the export after any SVG
edit.

---

## Outputs and target filenames

Nothing in this table is generated by default. Cut a variant when a real
surface needs it, and add the row then.

`alternatives/` and `concept_*/` do not exist. They are created only when a
real surface needs them — do not scaffold them empty.

| Output | Target filename | Recipe / concept |
| --- | --- | --- |
| Monochrome mark, SVG | `alternatives/logo_mark_mono.svg` | 1 |
| Monochrome mark, PNG 512 | `alternatives/logo_mark_mono.png` | 1 |
| Tile-less mark, SVG | `alternatives/logo_mark_tileless.svg` | 2 |
| Tile-less mark, PNG 512 | `alternatives/logo_mark_tileless.png` | 2 |
| Favicon PNG 16 / 32 / 48 | `alternatives/favicon-16.png`, `favicon-32.png`, `favicon-48.png` | 3 |
| Favicon multi-size `.ico` | `alternatives/favicon.ico` | 3 |
| Favicon SVG | `alternatives/favicon.svg` | 3 |
| Launcher source 1024 | `alternatives/ic_launcher_1024.png` | 4 |
| Android `mipmap-*/ic_launcher.png` | `mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png` | 4 |
| iOS AppIcon source | `AppIcon.appiconset/icon-1024.png` | 4 |
| OG image 1200×630 | `alternatives/og-1200x630.png` | 5 |
| Social avatar 400×400 | `alternatives/avatar-400x400.png` | 5 |
| Wordmark only | `alternatives/logo_wordmark.svg` | 6 |
| Stacked lockup | `alternatives/logo_stacked.svg` | 6 |
| Outlined lockup + print PDF | `alternatives/logo_full_outlined.svg`, `logo_full.pdf` | 7 |
| Concept mark, SVG (light) | `concept_<slug>/logo_mark.svg` | A / B / C |
| Concept mark, SVG (dark) | `concept_<slug>/logo_mark_dark.svg` | A / B / C |
| Concept mark, PNG 512 (light) | `concept_<slug>/logo_mark.png` | A / B / C |
| Concept mark, PNG 512 (dark) | `concept_<slug>/logo_mark_dark.png` | A / B / C |

---

## Not included yet

- **Launcher icon.** The packaged mark is what goes in `mipmap-*/ic_launcher.png`
  (Android) and the iOS AppIcon set when you next cut a store build. Export at
  1024×1024 from `logo_mark.svg`. Not wired here because it is a native
  resource, not an app asset, and it only matters at release time.
- **Monochrome / favicon `.ico` / social avatar.** Add when a web or store
  listing actually needs them — the mark already works at 16px if you export it
  from `logo_mark.svg`.

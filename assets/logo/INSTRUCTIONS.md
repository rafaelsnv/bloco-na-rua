# Bloco na Rua — Logo Build Instructions (no assets required)

This document is self-sufficient. Everything needed to draw, export and ship
the logo is written here. No existing artwork, source file, font file or
template has to be present — the mark can be reconstructed from the numbers in
this document alone.

Subject of the mark: a **fanfarra horn** (brass fanfare trumpet) firing a
**gold sunburst**, on a rounded violet tile.

**How to use this document**

1. Read section 2 (palette) and section 3 (rules that never change).
2. Draw the mark following section 4, step by step.
3. Draw the lockups following section 5.
4. Export with section 6.
5. Derive the surface-specific variants with section 7.
6. Optionally build the three new brand marks with section 8.
7. Verify with the checklist in section 9.

---

## 1. Canvases

| Element | Width × Height | viewBox |
| --- | --- | --- |
| Mark (symbol alone) | 64 × 64 | `0 0 64 64` |
| Full lockup (mark + wordmark) | 208 × 80 | `0 0 208 80` |
| Stacked lockup | 208 × 132 | `0 0 208 132` |
| Wordmark only | 138 × 80 | `70 0 138 80` |

---

## 2. Palette

Four roles, two brand colours plus one accent. Never introduce a fifth colour,
never change a hex.

| Role | Light surface | Dark surface |
| --- | --- | --- |
| Tile / brand | `#7C3AED` | `#A78BFA` |
| Main shape (horn, shield, drum shell) | `#FFFFFF` | `#2E1065` |
| Energy / accent (sunburst, rim, pennant) | `#FBBF24` | `#D97706` |
| Ink (wordmark text) | `#1C1917` | `#FAFAF9` |

Reference surfaces:

| Surface type | Colour |
| --- | --- |
| Light surface | `#FAFAF9` |
| Dark surface | `#111827` |
| Dark surface (elevated) | `#1F2937` |

The dark variant mirrors the product's own light/dark theme inversion: the
light theme is a violet tile with a white horn; the dark theme is a
light-violet tile with a dark-violet horn.

---

## 3. Rules that never change

- **Flat fills only.** No gradients, no drop shadows, no strokes, no outlines.
  The single exception is the tile-less variant, where the main shape is
  *filled* in the ink colour instead of white — still a flat fill.
- **Never recolour outside the palette.**
- **Never stretch a lockup.** Scale proportionally. The wordmark is positioned
  for one specific typeface and reflows with any other.
- **Never rotate, add a gradient, outline or shadow to a finished logo.**
- **Choose the variant by the surface *behind* the logo**, not by the
  surrounding interface theme.
- **Clear space:** keep at least 12.5% of the mark's width free on all sides
  (one eighth of the tile). Nothing else inside that box.
- **Minimum sizes:** mark 24px, full lockup 120px wide, stacked lockup 96px
  wide, wordmark only 80px wide. Below the mark minimum the internal detail
  fills in and the horn turns into a blob — favicons only.
- **Two marks in one view are forbidden.** Use the mark where the product name
  is already present; use the lockup only for standalone moments.
- **The source is vector.** Raster files are always exported from the vector
  drawing; never redraw at a small size.

---

## 4. Drawing the mark (64 × 64)

Work in a 64 × 64 canvas. Draw in this order: tile → sunburst group →
valve buttons → horn.

### 4.1 Tile

A rounded square covering the whole canvas, corner radius 18:

```xml
<rect width="64" height="64" rx="18" fill="#7C3AED"/>
```

Light surface uses `#7C3AED`, dark surface uses `#A78BFA`.

### 4.2 Artwork space and transform

All artwork is drawn in a **local coordinate space** whose origin is the
artwork centre, then placed on the tile with a single transform:

```xml
<g transform="translate(29.43 36.36) rotate(-35) scale(0.92)">
```

Meaning of each part:

| Part | Effect |
| --- | --- |
| `scale(0.92)` | shrinks the artwork to 92% of local size |
| `rotate(-35)` | tilts the artwork 35° counter-clockwise (the horn points up-and-right) |
| `translate(29.43 36.36)` | moves the artwork origin to roughly the tile centre (slightly below and right of it) |

In local space **+x points toward the burst**, **+y points down**, and the
origin is the pivot for the sunburst rays.

### 4.3 Sunburst (accent colour)

The burst consists of **5 tapered rays** radiating from the point
**P = (6, 0)** in local space, plus **3 valve buttons** further back.

**Ray shape** (drawn once, then repeated by rotation):

```xml
<path d="M15 -2.6 L24 -0.9 L24 0.9 L15 2.6 Z"/>
```

That is: a quad starting 15 units from P, tapering from 5.2 units tall at the
base to 1.8 units tall at the tip, 9 units long. The centre ray is slightly
heavier:

```xml
<path d="M15 -3 L24 -1 L24 1 L15 3 Z"/>
```

**Ray placement** — 5 rays, all rotating about P, all in one group:

```xml
<g fill="#FBBF24">
  <g transform="translate(6 0)">
    <g transform="rotate(-50)"><path d="M15 -2.6 L24 -0.9 L24 0.9 L15 2.6 Z"/></g>
    <g transform="rotate(-25)"><path d="M15 -2.6 L24 -0.9 L24 0.9 L15 2.6 Z"/></g>
    <path d="M15 -3 L24 -1 L24 1 L15 3 Z"/>
    <g transform="rotate(25)"><path d="M15 -2.6 L24 -0.9 L24 0.9 L15 2.6 Z"/></g>
    <g transform="rotate(50)"><path d="M15 -2.6 L24 -0.9 L24 0.9 L15 2.6 Z"/></g>
  </g>
</g>
```

The middle ray is not wrapped in a rotate group (angle 0). The fan spans
−50° to +50°, so the burst opens at 100°. When drawing by hand instead of in
SVG, place the rays at −50°, −25°, 0°, +25°, +50° around P.

**Valve buttons** — three small rounded rectangles sitting on top of the
horn tube, in the same accent colour, inside the same group as the rays:

```xml
<rect x="-19.1" y="-7.6" width="2.2" height="2.6" rx="1.1"/>
<rect x="-15.6" y="-7.6" width="2.2" height="2.6" rx="1.1"/>
<rect x="-12.1" y="-7.6" width="2.2" height="2.6" rx="1.1"/>
```

Spacing between button origins: 3.5 units. Fully rounded ends (`rx` = half the
width). They sit on the tube's upper edge, which is at local y = −5.

### 4.4 Horn (main shape)

Draw the horn **after** the sunburst so it overlaps the rays' inner ends, and
give it the main-shape colour (`#FFFFFF` on light surfaces, `#2E1065` on dark
surfaces):

```xml
<path fill="#FFFFFF" d="M-25 -2.6 L-20 -5 L-10 -5 C-2 -5.4 2.5 -8.5 6 -11.8 A3.5 11.8 0 0 1 6 11.8 C2.5 8.5 -2 5.4 -10 5 L-20 5 L-25 2.6 Z"/>
```

How to construct it by hand, in local space, left to right:

1. **Mouthpiece end** at x = −25: a narrow flat end 5.2 units tall
   (y = −2.6 to +2.6).
2. Run to x = −20, where the body steps up to 10 units tall
   (y = −5 to +5). This is the narrow cylindrical section of the tube.
3. From x = −10 the body flares outward: a curve reaching y = −11.8 at x = +6
   on the upper side, and the mirrored y = +11.8 on the lower side.
4. Close the bell mouth with a shallow convex arc from (6, −11.8) to
   (6, +11.8) — an elliptical arc with radii 3.5 × 11.8, bulging outward
   (to the right). The bell mouth is therefore 23.6 units tall, the widest
   point of the whole mark.
5. Return along the lower flare to (−10, 5), (−20, 5) and the mouthpiece end
   (−25, 2.6), closing the shape.

Total length 31 units, so after the 0.92 scale the horn is ~28.5 units long
inside a 64-unit tile.

### 4.5 Dark-surface variant

Same drawing, three colour swaps only:

| Element | Light | Dark |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Sunburst + valve buttons | `#FBBF24` | `#D97706` |
| Horn | `#FFFFFF` | `#2E1065` |

### 4.6 Accessibility markup

Give the drawing a title and a description, and a role:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64" role="img" aria-label="Bloco na Rua">
  <title>Bloco na Rua — mark (light surfaces)</title>
  <desc>Fanfarra horn + sunburst on a violet tile. For light backgrounds.</desc>
  ...
</svg>
```

---

## 5. Drawing the lockups

### 5.1 Wordmark

| Property | Value |
| --- | --- |
| Typeface | **Sora**, weight **700** |
| Size | **30px** |
| Line 1 | `Bloco` |
| Line 2 | `na Rua` |
| Line 1 colour | brand colour (`#7C3AED` / `#A78BFA`) |
| Line 2 colour | ink colour (`#1C1917` / `#FAFAF9`) |

Load Sora from Google Fonts, and keep the import in anything a browser will
render:

```
@import url('https://fonts.googleapis.com/css2?family=Sora:wght@700&display=swap');
```

```css
.w { font-family: 'Sora', 'Segoe UI', sans-serif; font-weight: 700; font-size: 30px; }
```

If Sora is unavailable, the browser falls back to a generic sans-serif and the
wordmark's width changes. For print, convert the text to outlines (section
7.7) instead of accepting the fallback.

### 5.2 Full lockup — 208 × 80

- Place the finished mark (section 4) at `transform="translate(6 8)"` — 6 units
  from the left, 8 units from the top.
- Both text lines start at `x="86"`, left-aligned:
  - `Bloco` at `y="36"`
  - `na Rua` at `y="68"`

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 208 80" width="208" height="80" role="img" aria-label="Bloco na Rua">
  <title>Bloco na Rua — full lockup (light surfaces)</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Sora:wght@700&display=swap');
    .w { font-family: 'Sora', 'Segoe UI', sans-serif; font-weight: 700; font-size: 30px; }
  </style>
  <g transform="translate(6 8)">
    ... mark (section 4) ...
  </g>
  <text class="w" x="86" y="36" fill="#7C3AED">Bloco</text>
  <text class="w" x="86" y="68" fill="#1C1917">na Rua</text>
</svg>
```

For the dark-surface lockup, apply the section 4.5 colour swaps plus the ink
colour `#FAFAF9` on `na Rua`.

### 5.3 Wordmark only — 138 × 80

- Draw the lockup, then delete the entire mark group (the `<g>` that holds the
  tile and artwork) and everything inside it.
- Reset the canvas to `viewBox="70 0 138 80"`, `width="138" height="80"` so the
  text is not clipped.
- Keep the two text lines at their original `x`, `y`.

### 5.4 Stacked lockup — 208 × 132

- Canvas: `viewBox="0 0 208 132"`, `width="208" height="132"`.
- Move the mark to the horizontal centre: `transform="translate(72 8)"`.
- Centre both text lines: `x="104"` with `text-anchor="middle"`.
- Re-space the lines: `Bloco` at `y="96"`, `na Rua` at `y="124"`.

```xml
<text class="w" x="104" y="96" text-anchor="middle" fill="#7C3AED">Bloco</text>
<text class="w" x="104" y="124" text-anchor="middle" fill="#1C1917">na Rua</text>
```

---

## 6. Exporting

Use Inkscape (or any vector tool with equivalent output). Export the vector
source to PNG at 512 px wide for the standard raster:

```
inkscape logo_mark.svg --export-type=png --export-filename=logo_mark.png --export-width=512
```

Always export the raster **from the vector source**, never by resizing an
existing PNG. Re-export after every edit to the vector drawing.

Naming convention:

| Output | Filename |
| --- | --- |
| Mark, vector, light surface | `logo_mark.svg` |
| Mark, vector, dark surface | `logo_mark_dark.svg` |
| Lockup, vector, light surface | `logo_full.svg` |
| Lockup, vector, dark surface | `logo_full_dark.svg` |
| Mark, raster 512, light surface | `logo_mark.png` |
| Mark, raster 512, dark surface | `logo_mark_dark.png` |
| Review sheet (both variants at 40/32/24px on light and dark surfaces) | `preview.svg` / `preview.png` |

---

## 7. Deriving variants

Create the target folder only when a real surface needs the output — do not
scaffold empty folders.

### 7.1 Monochrome / single-colour mark

**Use when the medium cannot hold more than one colour:** embroidery,
single-colour print, vinyl cutting, embossing, laser engraving, browser tab
favicons, official/legal use where the brand colour may not be reproduced.

**Recipe.**

1. Duplicate the mark drawing.
2. Replace **every** fill with a single value. The mark has exactly three
   fills: the tile, the sunburst group (rays + valve buttons) and the horn
   path. All three become the same colour:

   ```xml
   <rect width="64" height="64" rx="18" fill="#FFFFFF"/>
   <g fill="#FFFFFF">
     ...
     <path fill="#FFFFFF" d="M-25 -2.6 L-20 -5 ..."/>
   </g>
   ```

3. Pick the colour by surface:

   | Surface | Mono colour |
   | --- | --- |
   | Dark footer, slate, near-black | `#FFFFFF` |
   | Print on white paper | `#7C3AED` |
   | Print on coloured stock | `#FFFFFF` |

4. Export at 512 px wide.

The tile stays: a monochrome mark still needs a silhouette.

### 7.2 Tile-less (transparent background) mark

**Use on coloured surfaces** where the violet tile would clash — a violet
banner, a photo, a coloured header.

**Consequence to handle:** the horn is white. On a white surface it vanishes.
So on a tile-less mark the horn is **filled with the ink colour**, not
outlined, and not left white.

**Recipe.**

1. Duplicate the mark drawing.
2. Delete the tile rectangle entirely:

   ```xml
   <!-- delete this -->
   <rect width="64" height="64" rx="18" fill="#7C3AED"/>
   ```

3. Recolour the horn and the sunburst for the surface it will sit on:

   | Surface behind | Horn fill | Sunburst + buttons fill |
   | --- | --- | --- |
   | Light (`#FAFAF9`) | `#1C1917` | `#FBBF24` |
   | Dark (`#111827`, `#1F2937`) | `#FAFAF9` | `#D97706` |

4. Export with the alpha channel preserved:

   ```
   inkscape logo_mark_tileless.svg --export-type=png \
     --export-filename=logo_mark_tileless.png --export-width=512 --export-background-opacity=0
   ```

A tile-less mark on the wrong surface is invisible. Always match the surface
behind it.

### 7.3 Favicon and `.ico`

Vector editors in general cannot write `.ico` — export PNGs and pack them with
ImageMagick, which does the multi-size file in one step.

**Recipe.**

1. Export three PNG sizes from the light-surface mark (a browser tab bar is
   usually light):

   ```
   inkscape logo_mark.svg --export-type=png --export-filename=favicon-16.png --export-width=16
   inkscape logo_mark.svg --export-type=png --export-filename=favicon-32.png --export-width=32
   inkscape logo_mark.svg --export-type=png --export-filename=favicon-48.png --export-width=48
   ```

2. Pack them into a multi-size `.ico`:

   ```
   magick favicon-16.png favicon-32.png favicon-48.png favicon.ico
   ```

3. If ImageMagick is unavailable, use Python + Pillow:

   ```
   python -c "from PIL import Image; Image.open('favicon-16.png').save('favicon.ico', sizes=[(16,16),(32,32),(48,48)])"
   ```

4. Also ship an SVG favicon — sharpest at any pixel density, one file:

   ```
   <link rel="icon" href="/favicon.svg" type="image/svg+xml">
   <link rel="alternate icon" href="/favicon.ico" sizes="48x48">
   ```

Below 24px the valve buttons fill in and the horn becomes a blob. That is
acceptable for a favicon and for nothing else.

### 7.4 Launcher / app icon

**Recipe.**

1. Export a 1024 × 1024 source from the mark:

   ```
   inkscape logo_mark.svg --export-type=png --export-filename=ic_launcher_1024.png --export-width=1024
   ```

2. Android launcher icons — five densities, one file each:

   | Density | Size | Folder |
   | --- | --- | --- |
   | mdpi | 48×48 | `mipmap-mdpi/` |
   | hdpi | 72×72 | `mipmap-hdpi/` |
   | xhdpi | 96×96 | `mipmap-xhdpi/` |
   | xxhdpi | 144×144 | `mipmap-xxhdpi/` |
   | xxxhdpi | 192×192 | `mipmap-xxxhdpi/` |

   ```
   inkscape logo_mark.svg --export-type=png --export-filename=mipmap-mdpi/ic_launcher.png --export-width=48
   inkscape logo_mark.svg --export-type=png --export-filename=mipmap-hdpi/ic_launcher.png --export-width=72
   inkscape logo_mark.svg --export-type=png --export-filename=mipmap-xhdpi/ic_launcher.png --export-width=96
   inkscape logo_mark.svg --export-type=png --export-filename=mipmap-xxhdpi/ic_launcher.png --export-width=144
   inkscape logo_mark.svg --export-type=png --export-filename=mipmap-xxxhdpi/ic_launcher.png --export-width=192
   ```

3. iOS — the asset catalog wants a **single 1024 × 1024 source**; the platform
   scales the rest. Save it as `AppIcon.appiconset/icon-1024.png` and declare
   it:

   ```json
   {
     "images": [
       { "filename": "icon-1024.png", "idiom": "universal", "platform": "ios", "size": "1024x1024" }
     ],
     "info": { "author": "xcode", "version": 1 }
   }
   ```

   The App Store slot requires **no transparency and no alpha channel** —
   export with an opaque background:

   ```
   inkscape logo_mark.svg --export-type=png \
     --export-filename=AppIcon.appiconset/icon-1024.png \
     --export-width=1024 --export-background="#7C3AED" --export-background-opacity=1
   ```

4. **Adaptive icon (Android).** The platform masks the artwork to the inner
   80% of the canvas and may crop to a squircle, blob or full square. The
   artwork group is scaled `0.92` inside the 64 × 64 tile and the bell and
   rays reach slightly past that inner circle, so they would be clipped. For
   an adaptive icon, change the artwork group scale from `0.92` to about
   `0.85`:

   ```xml
   <g transform="translate(29.43 36.36) rotate(-35) scale(0.85)">
   ```

   Then export the foreground layer at the adaptive sizes (108dp canvas, 72dp
   safe zone) as `ic_launcher_foreground.png`, with a flat `#7C3AED` layer as
   `ic_launcher_background.png`.

### 7.5 Social avatar and Open Graph image

This is the only recipe that adds a background — a **flat** brand violet
`#7C3AED` field, never a gradient.

**Open Graph image, 1200 × 630.**

1. Compose a wrapper that places the lockup on the violet field. Recolor the
   wordmark for a violet ground, otherwise brand-violet text on a violet field
   is invisible: `Bloco` in `#FFFFFF`, `na Rua` in `#FAFAF9`.

   ```xml
   <svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
     <rect width="1200" height="630" fill="#7C3AED"/>
     <g transform="translate(496 275)">
       <image href="logo_full.svg" width="208" height="80"/>
     </g>
   </svg>
   ```

   If the renderer will not resolve external references, inline the lockup
   markup instead of using `<image href>` and set the two text fills to
   `#FFFFFF` / `#FAFAF9`.

2. Export at 1200 px wide.

**Avatar, 400 × 400.** Same violet field, mark centred:

```
inkscape avatar-400x400.svg --export-type=png --export-filename=avatar-400x400.png --export-width=400
```

Use the mark alone at 400px. The full lockup at 400px is too small to read.

### 7.6 Wordmark-only and stacked lockups

Both are specified in section 5 (5.3 and 5.4). Reminder: the font import must
survive for browser rendering; convert to outlines only for print.

### 7.7 Print and PDF preparation

Anything sent to a printer needs the web-loaded font turned into outlines, or
the printer's RIP substitutes a different face.

**Recipe.**

1. Install **Sora 700** locally. The Google Fonts import resolves in a
   browser only; it does not resolve in a vector editor without network
   access, and never in a PDF at the printer.
2. Convert the text to paths: select the `<text>` objects and use
   `Path > Object to Path` (or `Shift+Ctrl+C`). The text becomes a `<path>`
   and the font import in the `<style>` block can then be dropped.
3. Export the PDF:

   ```
   inkscape logo_full_outlined.svg --export-type=pdf \
     --export-filename=logo_full.pdf --export-text-to-path
   ```

4. Check the PDF before sending it: the wordmark must be a filled outline and
   not selectable text, and no colour may have been swapped.

If the printer wants CMYK, convert the flat fills in the vector editor **after**
outlining the text — never after rasterising.

---

## 8. New brand marks (optional, not built)

Three alternative brand ideas, given as build specifications. None of them
exists as artwork — draw them from these numbers. They follow the same rules
(section 3), the same 64 × 64 mark canvas, the same tile
`<rect width="64" height="64" rx="18">`, the same palette and the same export
command.

Shared construction rules for all three:

- Canvas `viewBox="0 0 64 64"`; if a tile is used it is
  `<rect width="64" height="64" rx="18">`, the same tile as the main mark.
- Coordinates below are already in the 64 × 64 space — do **not** apply the
  main mark's `translate(29.43 36.36) rotate(-35) scale(0.92)` transform.
- Palette roles: tile `#7C3AED` / `#A78BFA`, main shape `#FFFFFF` / `#2E1065`,
  energy `#FBBF24` / `#D97706`, ink `#1C1917` / `#FAFAF9`.
- Keep 12.5% clear space; minimum 24px for a mark, 120px for a lockup.
- Export at 512 px wide and review at 40 / 32 / 24px on `#FAFAF9` and
  `#111827`.

### 8.1 Concept A — "Repineta" (street drum)

**Idea.** The drum every bloco carries on the street, mid-march, with rhythm
marks trailing behind it: a bloco *moving through the street*, rather than a
static instrument playing.

**Composition.**

- **Dominant shape.** A drum head seen slightly from above — an ellipse tilted
  `−12°`, roughly 34 units wide and 22 units tall, centred at about
  `(30 34)`. Below it a shallow shell body: a rounded trapezoid, `rx=4`,
  height 14, with a single accent-coloured rim band across the bottom.
- **Secondary shapes.** A drumstick above the ellipse, angled `−55°`, running
  from `(20 18)` to `(38 30)`. Three **rhythm chevrons** (`>`, 8 units wide,
  3 units thick, `−12°` tilt) trail off the upper-left of the shell at
  `(14 30)`, `(16 38)`, `(18 46)`, stepping down-left — the zig-zag beat of a
  repique.
- **Negative space.** Keep the shell's inner ring unfilled: the ellipse reads
  as a hollow drum head because the body below it is a separate solid mass.
  Leave the gap between the stick and the ellipse open, and the open band
  between the rim band and the shell bottom.

**Colour mapping.**

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Drum shell + drumstick | `#FFFFFF` | `#2E1065` |
| Rim band + rhythm chevrons | `#FBBF24` | `#D97706` |

**Assessment.**

| | |
| --- | --- |
| Small-size legibility | Strong — two solid masses plus a stick; nothing thinner than 3 units; survives 24px |
| Distinctiveness vs the horn mark | High — drum + chevrons, no shared silhouette |
| Cost to draw | Low — two ellipses, one trapezoid, one stick, three chevrons |
| Monochrome | Good if the chevrons keep their full length |
| Weakness | A drum is a generic percussion symbol; the chevrons carry the "street march" idea |

**Best used for:** login header, onboarding, app bar, favicon, print. The
chevrons give horizontal energy that suits a 208 × 80 lockup.

### 8.2 Concept B — "Saxofone"

**Idea.** A saxophone in profile, standing roughly vertical, with its notes
flying out of the bell and arranging themselves into the banner a bloco
carries at the head of the march.

**Composition.**

- **Dominant shape.** A saxophone in profile, body spanning `(20 14)` to
  `(40 52)`. The bell flares at the top-left (`rotate(-20°)` about
  `(24 16)`); the tube runs down and curves right at the bottom into a small
  upturned bell at `(40 50)`. One key-cluster notch on the upper right of the
  tube.
- **Secondary shapes.** A **flag/banner** in the upper right: a swallow-tail
  pennant on a short diagonal staff running from `(38 18)` up to `(46 10)`,
  the pennant spanning `(46 10)`–`(58 20)` with a `V` notch in its outer edge.
  Three **note marks** (circles of 2.5 units radius plus a short stem) rise
  between the sax bell and the pennant at `(28 10)`, `(34 8)`, `(39 12)`.
- **Negative space.** The open curve between the sax body and the bell flare —
  a crescent of tile colour on the upper left. It is the main break that
  keeps the mark from reading as a blob.

**Colour mapping.**

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Sax body + staff | `#FFFFFF` | `#2E1065` |
| Pennant + note marks | `#FBBF24` | `#D97706` |

**Assessment.**

| | |
| --- | --- |
| Small-size legibility | Weakest of the three — the curved tube and three note marks fill in fast, the pennant notch closes up; needs a 32px floor, not 24px |
| Distinctiveness vs the horn mark | Medium-high — different instrument family, but still "one instrument with rays off it" |
| Cost to draw | Highest — real bezier work on the sax profile, plus flag and staff |
| Monochrome | Mediocre — the tube and staff cross and merge; knock the tile out between staff and pennant |
| Weakness | Three competing focal points; the pennant can read as a separate element |

**Best used for:** onboarding and marketing illustrations, the login header at
large size, print. Not for the app bar, the bottom nav or a favicon.

### 8.3 Concept C — "Escudo da Fanfarra" (marching-band crest)

**Idea.** A heraldic badge, the way a marching band or a school of samba
carries a crest — a shield assembled from the fanfarra's own objects.

**Composition.**

- **Dominant shape.** A shield spanning `(10 8)` to `(54 40)`, with straight
  sides, a slight point at the bottom centre and an `rx=3` top edge, drawn as
  a single filled path.
- **Secondary shapes.** Two **horn silhouettes** mirrored left and right inside
  the upper shield, bells pointing outward-up, each about 16 units long,
  meeting near the centre. Three **carnival feathers** (tapered leaf paths,
  20 units long) fan out from behind the shield's top centre at `−25°`, `0°`,
  `+25°`. A **ribbon banner** across the bottom at `y=40`–`52`, wider than the
  shield's point, with forked tails at `(8 44)` and `(56 44)`.
- **Negative space.** The ribbon cuts a horizontal band across the shield's
  bottom point, so the shield reads as an upper field plus a ribbon instead of
  one solid blob. The space between the two mirrored horns holds the centre.

**Colour mapping.**

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` | `#A78BFA` |
| Shield body | `#FFFFFF` | `#2E1065` |
| Horns, feathers, ribbon | `#FBBF24` | `#D97706` |

**Assessment.**

| | |
| --- | --- |
| Small-size legibility | Good at silhouette level, poor in the interior — at 24px the horns and feathers turn into texture while the shield + ribbon still read |
| Distinctiveness vs the horn mark | Low-medium — the interior horns reuse the main mark's motif, just framed |
| Cost to draw | Highest — shield path, two mirrored horns, three feathers, ribbon with forked tails |
| Monochrome | Good — shield + ribbon silhouettes are enough; drop the interior horns |
| Weakness | The most conventional of the three and the closest to the existing brand; it changes no central idea |

**Best used for:** print, merchandise, the store listing, and as a full lockup
with the ribbon carrying the wordmark. As a 24px app icon the interior is
wasted space.

### 8.4 Choosing between the three

| | A — Repineta | B — Saxofone | C — Escudo |
| --- | --- | --- | --- |
| Distinctiveness | High | Medium-high | Low-medium |
| Small-size legibility | Strong (24px) | Weak (32px floor) | Good at silhouette, weak in detail |
| Distinctness from the horn mark | High | Medium-high | Low — reuses the horn motif |
| Implementation cost | Low | High | High |
| Recommended surface | App bar, bottom nav, favicon, login header | Onboarding, marketing, large print | Print, merchandise, store listing |

**Build A first.** It is the only concept carrying a new *idea* rather than a
new instrument: a drum mid-march with rhythm chevrons says "a bloco moving
through the street", which is what the product is about, while B says "a
saxophone" and C says "a marching band". It is also the cheapest to draw and
the most robust — two solid masses and four simple strokes, everything ≥3
units thick, which is exactly what survives the 24px minimum. Its chevrons
give the horizontal energy a 208 × 80 lockup next to a wordmark needs.

**Conditions that change the answer:**

- If the mark must work as a **monochrome stamp on merchandise** (single
  colour embroidery, vinyl, engraving) — take **A** only if the chevrons
  survive in one colour; otherwise take **C** and ship the shield silhouette
  alone.
- If the brand must stay **explicitly "fanfarra"** — take **C**; it is the
  only one that keeps a brass instrument inside the mark.
- If the mark is **mostly used large** (onboarding carousel, splash, print)
  and an app bar icon is not a priority — take **B**; the saxophone is the
  most expressive at large size.
- If a **store icon must double as the Android app icon** — take **A**; its
  silhouette sits inside the adaptive icon's inner circle far more
  comfortably than the shield's feathers.

**Producing a chosen concept.**

1. Create a folder named after the concept: `concept_repineta`,
   `concept_saxofone` or `concept_escudo`.
2. Draw the 64 × 64 mark from that concept's composition above: tile first,
   then the artwork in a single group.
3. Apply the colour-mapping table for the light and the dark variant.
4. Update `<title>` and `<desc>` to describe the new mark and the surface it
   is for.
5. Export both PNGs at 512 px wide.
6. Review at 40 / 32 / 24px on `#FAFAF9` and `#111827`. Anything that fills in
   below 24px is a favicon-only detail.
7. If the concept is adopted, cut the lockups too: 208 × 80, mark at
   `translate(6 8)`, wordmark `<text x="86">` in Sora 700 at 30px, `Bloco` in
   the brand colour and `na Rua` in the ink colour. Then apply the launcher
   icon, favicon, Open Graph and print recipes from section 7.

---

## 9. Verification checklist

Before shipping any output, confirm:

- [ ] Flat fills only — no gradients, shadows, strokes or outlines.
- [ ] Every colour comes from the section 2 palette.
- [ ] The variant matches the surface *behind* the logo, not the interface
      theme.
- [ ] At least 12.5% of the mark's width is free on all sides.
- [ ] Legible at 24px (mark) / 120px wide (lockup) — reviewed at 40, 32 and
      24px on both `#FAFAF9` and `#111827`.
- [ ] The tile is intact (unless the tile-less variant was requested).
- [ ] The sunburst still reads as five rays with three valve buttons.
- [ ] The wordmark is Sora 700 at 30px, `Bloco` in brand colour and `na Rua`
      in ink colour.
- [ ] Raster exports were produced from the vector source at the right size.
- [ ] Print output has the text converted to outlines.
- [ ] A dark-surface variant exists alongside the light one.

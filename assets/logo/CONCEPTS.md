# Bloco na Rua — New Logo Concepts

Three **new** brand ideas for the app. Not recolours of the incumbent fanfarra
horn + sunburst — those live in `assets/logo/README.md`, and variants of them
live in `assets/logo/ALTERNATIVES.md`.

**The artwork does not exist yet.** This document is the spec a designer or an
implementer builds from. Nothing here is cut.

## Files

| File | What it is |
| --- | --- |
| `assets/logo/README.md` | The incumbent logo. Source of truth for palette, usage rules, fonts, export command. |
| `assets/logo/ALTERNATIVES.md` | How to derive variants of the incumbent. |
| `assets/logo/CONCEPTS.md` | This file. Briefs for three new marks. |

`assets/logo/concept_*/` folders **do not exist**. Create a folder only when a
concept is actually built — do not scaffold them empty.

---

## Shared rules

These do not change per concept. They come from `assets/logo/README.md` and
`assets/logo/ALTERNATIVES.md`; reuse them verbatim, do not invent new ones.

- **Same palette only.** Every fill is an existing app token from
  `lib/ui/core/tokens/app_colors.dart`. The logo introduces no new colour.
- **Flat fills only.** No gradients, no shadows, no strokes, no outlines.
- **Mark canvas.** `viewBox="0 0 64 64"` for a mark. If a tile is used, it is
  `<rect width="64" height="64" rx="18">` — the same tile as the incumbent.
- **Clear space.** Keep at least 12.5% of the mark's width (one eighth of the
  tile) free on all sides. Nothing else inside that box.
- **Minimum size.** Mark: 24px. Below that the internal detail fills in and the
  shape turns into a blob — acceptable only as a favicon, not as UI. Full
  lockup: 120px wide.
- **Wordmark.** Sora 700 (the app's display face, used by
  `AppTypography.displayLarge`/`headline*`) via an `@import` of Google Fonts,
  in the 208×80 lockup at `x=86`, `font-size: 30px`.
- **Never stretch the lockup**, never recolour outside the palette, never add
  a gradient, outline or drop shadow.
- **Pick the variant that matches the surface behind the logo**, not the app
  theme.
- **Export.** Inkscape, at 512. The SVGs are the source; the PNGs are derived.

### Palette reference

Same four roles as the incumbent, so all three concepts are colour-compatible
with the existing lockup.

| Role | Light surface | Dark surface |
| --- | --- | --- |
| Tile / brand | `#7C3AED` (`AppColors.primary`) | `#A78BFA` (`AppColors.primaryLight`) |
| Main shape | `#FFFFFF` (`AppColors.textOnPrimary`) | `#2E1065` (`AppColors.textOnPrimaryDark`) |
| Secondary shape / energy | `#FBBF24` (`AppColors.accentLight`) | `#D97706` (`AppColors.accent`) |
| Ink (wordmark) | `#1C1917` (`AppColors.textPrimary`) | `#FAFAF9` (`AppColors.textPrimaryDark`) |

---

## A — "Repineta" (street drum)

### Idea + inspiration

The repineta is the drum every bloco carries on the street — a small snare that
sets the tempo the whole fanfarra follows. The concept is the drum mid-march:
a body being struck, with motion and rhythm marks trailing behind it. It
replaces the incumbent's static "instrument playing" idea with the app's
actual subject: a bloco **moving through the street**.

### Composition

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

### Colour mapping

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` (`AppColors.primary`) | `#A78BFA` (`AppColors.primaryLight`) |
| Drum shell + drumstick | `#FFFFFF` (`AppColors.textOnPrimary`) | `#2E1065` (`AppColors.textOnPrimaryDark`) |
| Rim band + rhythm chevrons | `#FBBF24` (`AppColors.accentLight`) | `#D97706` (`AppColors.accent`) |

### Strengths / weaknesses

| | |
| --- | --- |
| **Small-size legibility** | Strong. Two masses (oval + trapezoid) plus a stick; nothing is thinner than 3 units. Survives at 24px better than a horn. |
| **Distinctiveness vs incumbent** | High. The incumbent is brass + burst; this is a drum + chevrons. No shared silhouette. |
| **Cost to draw** | Low. Two ellipses, one trapezoid, one stick, three chevrons — no curves to tune beyond the drum head. |
| **Monochrome** | Good. The shell and stick merge into one white mass, but the chevrons still separate the left edge. Keep the chevrons at full length in mono. |
| **Weakness** | A drum is a generic percussion symbol — less specific to *fanfarra* than a horn. Needs the chevrons to carry the "street march" idea. |

### Best used for

Login header, onboarding, app bar, favicon, print. The chevrons give it
directional energy that works well in a horizontal lockup, and the drum reads
cleanly at 24px for a bottom-nav icon.

---

## B — "Saxofone"

### Idea + inspiration

A saxophone in profile — the instrument that carries the melody over the
battery's noise. The concept is the sax mid-solo, its notes flying out of the
bell and arranging themselves into the banner/flag a bloco carries at the
front of the march. It pairs the app's two real subjects: the sound and the
street procession.

### Composition

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

### Colour mapping

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` (`AppColors.primary`) | `#A78BFA` (`AppColors.primaryLight`) |
| Sax body + staff | `#FFFFFF` (`AppColors.textOnPrimary`) | `#2E1065` (`AppColors.textOnPrimaryDark`) |
| Pennant + note marks | `#FBBF24` (`AppColors.accentLight`) | `#D97706` (`AppColors.accent`) |

### Strengths / weaknesses

| | |
| --- | --- |
| **Small-size legibility** | Weakest of the three. The curved tube and three separate note marks fill in fast; the pennant notch closes up. Needs a 32px floor rather than 24px. |
| **Distinctiveness vs incumbent** | Medium-high. A sax is a different instrument family and a different shape language, but it is still "one instrument with rays off it" — the burst becomes a flag. |
| **Cost to draw** | Highest. A convincing sax profile needs real bezier work and careful tuning; the flag and staff add more. |
| **Monochrome** | Mediocre. The tube and staff cross, so a single fill merges them. Needs the tile knocked out between the staff and the pennant to survive. |
| **Weakness** | The busiest composition. Notes + flag + instrument = three competing focal points, and the pennant can be mistaken for a separate logo element. |

### Best used for

Onboarding and marketing illustrations, the login header at large size, print.
Not recommended for the app bar, the bottom nav or a favicon — too much detail
for those.

---

## C — "Escudo da Fanfarra" (marching-band crest)

### Idea + inspiration

A badge, the way a marching band or a school of samba carries a crest. The
concept is a shield assembled from the fanfarra's own objects: horn
silhouettes, carnival feathers, and a ribbon banner across the bottom that
carries the name. It is the most "heraldic" of the three and the most
obviously Brazilian-carnival in reference.

### Composition

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

### Colour mapping

| Part | Light surface | Dark surface |
| --- | --- | --- |
| Tile | `#7C3AED` (`AppColors.primary`) | `#A78BFA` (`AppColors.primaryLight`) |
| Shield outline / shield body | `#FFFFFF` (`AppColors.textOnPrimary`) | `#2E1065` (`AppColors.textOnPrimaryDark`) |
| Horns, feathers, ribbon | `#FBBF24` (`AppColors.accentLight`) | `#D97706` (`AppColors.accent`) |

### Strengths / weaknesses

| | |
| --- | --- |
| **Small-size legibility** | Good at the silhouette level, poor in the interior. At 24px the horns and feathers turn into texture; the shield + ribbon still reads. |
| **Distinctiveness vs incumbent** | Low-medium. The horns inside the shield are the same motif as the incumbent — horn plus gold energy — just framed. |
| **Cost to draw** | Highest. Shield path, two mirrored horns, three feathers, ribbon with forked tails: four distinct sub-shapes. |
| **Monochrome** | Good. A shield silhouette plus a ribbon silhouette is enough; drop the interior horns and keep the shield. |
| **Weakness** | The most conventional of the three, and the closest to the incumbent. It reads as "marching band", which is the app's world, but it does not change the brand's central idea. |

### Best used for

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
| `assets/logo/concept_<slug>/logo_mark.svg` | Mark, light surface. `viewBox="0 0 64 64"`. Source of truth. |
| `assets/logo/concept_<slug>/logo_mark_dark.svg` | Same artwork, dark-surface colours. |
| `assets/logo/concept_<slug>/logo_mark.png` | 512×512 raster of `logo_mark`. |
| `assets/logo/concept_<slug>/logo_mark_dark.png` | 512×512 raster of `logo_mark_dark`. |

`<slug>` is the concept's short name: `repineta`, `saxofone`, `escudo`.

Steps:

1. **Create the folder** — only for the concept actually being built.

   ```
   New-Item -ItemType Directory assets/logo/concept_repineta
   ```

2. **Copy the incumbent mark** as the starting point, to inherit the tile, the
   viewBox and the `<title>`/`<desc>` structure:

   ```
   Copy-Item assets/logo/logo_mark.svg assets/logo/concept_repineta/logo_mark.svg
   Copy-Item assets/logo/logo_mark.svg assets/logo/concept_repineta/logo_mark_dark.svg
   ```

3. **Replace the artwork group** with the concept's geometry from this brief.
   Keep the `<rect width="64" height="64" rx="18">` tile as the first child and
   put the new artwork in a single `<g>` after it. Drop the incumbent's
   `transform="translate(29.43 36.36) rotate(-35) scale(0.92)"` — the
   coordinates in this brief are already in the 64×64 space.

4. **Apply the colour mapping** table for the variant. Light surface: tile
   `#7C3AED`, main `#FFFFFF`, energy `#FBBF24`. Dark surface: tile `#A78BFA`,
   main `#2E1065`, energy `#D97706`.

5. **Update `<title>` and `<desc>`** in both SVGs to describe the new mark and
   the surface it is for.

6. **Export the PNGs** with Inkscape, at 512:

   ```
   inkscape assets/logo/concept_repineta/logo_mark.svg --export-type=png \
     --export-filename=assets/logo/concept_repineta/logo_mark.png --export-width=512
   inkscape assets/logo/concept_repineta/logo_mark_dark.svg --export-type=png \
     --export-filename=assets/logo/concept_repineta/logo_mark_dark.png --export-width=512
   ```

7. **Review at 40 / 32 / 24px** on both `#FAFAF9` and `#111827`. Anything that
   fills in below 24px is a favicon-only detail.

8. **If the concept is adopted**, cut the lockup too — `logo_full.svg` /
   `logo_full_dark.svg`, 208×80 viewBox, mark at `translate(6 8)`, wordmark
   `<text x="86">` in Sora 700 at `font-size: 30px`, `Bloco` in the brand
   colour and `na Rua` in the ink colour. Then follow
   `assets/logo/ALTERNATIVES.md` for the launcher icon, favicon, OG image and
   print prep.

The SVGs are the source; the PNGs are derived. Re-run the export after any SVG
edit.

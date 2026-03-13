# Dragon Seal — Art Direction Research

Reference notes for `apps/web-sirgrimorum/public/dragon-seal.svg`.
Two topics: (1) steampunk wax stamp seal aesthetics in SVG, (2) oriental dragon in steampunk pixel art style.

---

## Part 1: Steampunk Wax Stamp Seal in SVG

### Physical Reality to Simulate

A real wax seal has specific optical properties that must be translated into vector:

- **Dome profile** — wax pools convex, highest at center, tapering toward irregular organic edges. Use a radial gradient with a bright focal point shifted slightly upper-left.
- **Rim irregularity** — the outer edge is never a perfect circle. Use a `<path>` with subtle wobble, not a `<circle>`.
- **Impressed motif** — the stamp face sinks into the hot wax (debossed): darker inside the impression, bright rim highlight on the upper-left lip.
- **Surface sheen** — semi-gloss: one small, soft, off-center specular highlight (upper-left), not a broad shine.
- **Translucency at rim** — reduce `fill-opacity` or fade gradient at outermost path edge.

### Layer Stack (back to front)

1. Drop shadow beneath entire seal
2. Base wax body — blob `<path>` with radial gradient
3. Texture overlay — `feTurbulence` filter
4. Border / rim ornament ring
5. Impressed center motif (debossed fill + highlight-shadow pair)
6. Specular highlight — small blurred white ellipse, low opacity

### SVG Gradient for Dome Effect

```xml
<radialGradient id="waxDome"
  cx="42%" cy="38%"
  r="55%"
  fx="38%" fy="32%">
  <stop offset="0%"   stop-color="#d4813a"/>  <!-- specular highlight -->
  <stop offset="35%"  stop-color="#b5622a"/>  <!-- diffuse lit face -->
  <stop offset="75%"  stop-color="#7a3810"/>  <!-- shadow transition -->
  <stop offset="100%" stop-color="#4a1f06" stop-opacity="0.9"/>  <!-- rim dark -->
</radialGradient>
```

Shift `cx`/`cy` and `fx`/`fy` upper-left (~38–42% x, 30–38% y). Always use 4 stops minimum — 2-stop gradients look flat.

### feTurbulence for Organic Wax Surface

```xml
<filter id="waxTexture" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence
    type="turbulence"
    baseFrequency="0.65"
    numOctaves="4"
    seed="2"
    result="noiseMap"/>
  <feDisplacementMap
    in="SourceGraphic"
    in2="noiseMap"
    scale="8"
    xChannelSelector="R"
    yChannelSelector="G"/>
</filter>
```

- `baseFrequency` 0.4–0.8 is the wax-appropriate range (higher = finer grain)
- `scale` 5–15 for subtle wax edge wobble
- Use `type="fractalNoise"` for softer, dusty matte bloom overlay

### Embossed vs. Debossed Motif

For a wax seal, **debossed** is physically correct (stamp sinks into wax):
- Fill the motif paths slightly darker than surrounding wax (~20% darker)
- Add a 1–2px highlight "line" on the upper-left edge (white, 40% opacity)
- Add a 1–2px shadow "line" on the lower-right edge (black, 30% opacity)
- SVG trick: render two offset copies of each path — one at (-1,-1) in white, one at (+1,+1) in black, both low opacity

Alternative with filters:
```xml
<filter id="embossMotif">
  <feGaussianBlur stdDeviation="1.5" result="blur"/>
  <feDiffuseLighting in="blur" lighting-color="white"
    surfaceScale="3" diffuseConstant="1.2" result="diffLight">
    <feDistantLight azimuth="225" elevation="45"/>
  </feDiffuseLighting>
  <feComposite in="diffLight" in2="SourceGraphic" operator="in"/>
</filter>
```

### Specular Highlight on Dome

A single blurred white ellipse, positioned at ~38% x / 32% y of the seal:
- Fill white, opacity 0.18–0.28
- `feGaussianBlur stdDeviation="4"`
- This single element does more to sell "molten wax" than any other technique

### Drop Shadow

```xml
<filter id="sealShadow" x="-20%" y="-20%" width="140%" height="140%">
  <feDropShadow dx="3" dy="5" stdDeviation="6"
    flood-color="#1a0800" flood-opacity="0.55"/>
</filter>
```

### Steampunk Border Vocabulary

| Border type | Construction | Notes |
|---|---|---|
| Gear-tooth ring | Polar path with trapezoidal teeth | 24–36 teeth, 10–14px tall, slightly narrower at tip than base |
| Rope/cable twist | Two interleaved helix paths in annular clip | Second inner ring after gears |
| Scalloped / coin edge | Small `<circle>` elements on perimeter arc | 40–60 bumps at seal scale |
| Rivet ring | Circle of `<circle r="3">` equidistant on radius | Between every 3rd gear tooth |
| Victorian filigree | Annular band with interlocking S-curves and diamonds | Innermost ring, closest to motif |

Victorian motif elements: acanthus scrollwork, cartouche frame for center text/monogram, crosshatch engraving fills on flat surfaces, ribbon banner for motto.

### Steampunk Color Palette (Brass/Copper)

| Role | Hex | Use |
|---|---|---|
| Bright brass highlight | `#E8C97A` | Gradient specular stop |
| Warm brass mid | `#C69C6D` | Main body color |
| Antique brass shadow | `#8B6040` | Shadow side of dome |
| Deep copper | `#B75727` | Alternative body tone |
| Oxidized copper (verdigris) | `#4A7C59` | Cool accent / patina detail |
| Dark espresso | `#2A201B` | Outermost rim, drop shadow |
| Charcoal near-black | `#1F1B17` | Text, line work |
| Parchment | `#EFE2C8` | Background (seal on paper) |

**Principles:**
1. Warm metallics (brass/copper) anchor the palette
2. Dark neutrals (espresso/charcoal) ground shadows and line work
3. One cool accent (verdigris) creates visual tension, sells "old metal"
4. Avoid pure saturated red — use `#8B1A1A`–`#A03020` (burgundy-brick) for red wax variants
5. Minimum 4 gradient stops on any wax body

### Quick-Reference Checklist

| Element | Technique | Key Parameter |
|---|---|---|
| Blob outer edge | Irregular `<path>` | 8–12 subtle perturbation points |
| Wax dome | `<radialGradient>` 4 stops | cx=42% cy=38%, focal upper-left |
| Surface noise | `feTurbulence` + `feDisplacementMap` | baseFrequency=0.6, scale=8 |
| Grain overlay | `feTurbulence fractalNoise` + `feBlend multiply` | opacity 0.15–0.25 |
| Impressed motif | Offset path pair or `feDiffuseLighting` | surfaceScale=3, azimuth=225 |
| Dome highlight | Blurred white `<ellipse>` | opacity 0.22, stdDeviation=4 |
| Drop shadow | `feDropShadow` | dx=3 dy=5 stdDeviation=6 |
| Outer border | Gear-tooth path ring | 24–36 teeth, 10–14px tall |
| Inner border | Rope-twist or scallop | Inset 8–12px from outer ring |

### Sources

- [Quick Tip: Wax Seal in Adobe Illustrator — Envato Tuts+](https://design.tutsplus.com/tutorials/quick-tip-how-to-create-a-wax-seal-with-adobe-illustrator--vector-4064)
- [SVG Filter Effects: feTurbulence — Codrops](https://tympanus.net/codrops/2019/02/19/svg-filter-effects-creating-texture-with-feturbulence/)
- [feTurbulence — MDN](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Element/feTurbulence)
- [feDisplacementMap — MDN](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Element/feDisplacementMap)
- [feSpecularLighting — Vanseo Design](https://vanseodesign.com/web-design/svg-filter-primitives-fespecularlighting/)
- [feConvolveMatrix emboss — Vanseo Design](https://vanseodesign.com/web-design/svg-filter-primitives-feconvolvematrix/)
- [Creating Patterns with SVG Filters — CSS-Tricks](https://css-tricks.com/creating-patterns-with-svg-filters/)
- [Steampunk Color Palette — media.io](https://www.media.io/color-palette/steampunk-color-palette.html)
- [The Colors of Steampunk — Steampunk Explorer](https://steampunk-explorer.com/articles/colors-steampunk)
- [Steampunk Forever palette — SchemeColor](https://www.schemecolor.com/steampunk-forever.php)
- [gggrain: grainy gradient SVG generator — fffuel](https://www.fffuel.co/gggrain/)

---

## Part 2: Oriental Dragon — Steampunk Pixel Art for Wax Seal

### Anatomy of the East Asian Dragon (Chinese Long / Japanese Ryū)

The oriental dragon is a composite of nine animals — fundamentally a serpent with augmented features:

| Part | Animal origin | Visual characteristic |
|---|---|---|
| Head | Camel / ox | Wide snout, prominent jaw |
| Eyes | Rabbit | Wide, alert — often bright red or gold |
| Ears | Cow / dog | Small, rounded |
| Horns | Deer | Branched antlers (not ram-like) |
| Body | Snake | Long, sinuous, no wings — dominant silhouette |
| Belly | Frog | Slightly distended, pale segmented underbelly |
| Scales | Carp | Overlapping fish-scale rows (~117 total: 81 yang + 36 yin) |
| Paws | Tiger | Hawk claws; 5 claws (Chinese imperial), 3 (Japanese Ryū), 4 (Korean) |
| Whiskers | Catfish / rat | Long, projecting from snout sides |

**Distinguishing details to include:**
- Single goatee/beard under chin
- Dorsal crest / flame-mane running head-to-tail
- No bat wings — flight is magical, not aerodynamic
- Flaming pearl (hōju/zhū) near the mouth — symbol of wisdom (optional but iconic)
- Underbelly plates: segmented, lighter tone than dorsal scales

**Japanese variation:** more slender, three claws, softer outlines, water/cloud associations over fire.

### Pixel Art Guidelines

**Grid resolution:**
- 64×64 is recommended working resolution — anatomical detail + steampunk elements without noise
- 32×32 minimum to convey serpentine body, claws, horns, whiskers
- 16×16 only viable for extreme abstraction

**Scale representation:**
- Full individual scale rows at 32px resolution read as noise — represent them as diagonal hatch lines or alternating pixel patterns in key areas (shoulders, mid-body only)
- Scale row pattern: horizontal band of offset half-ovals, each row shifted half a unit from the row above (roof-tile / fish-scale offset)
- Each scale: lighter arc highlight at top, darker shadow at overlap join below (2 tones per scale)
- Dithering: alternate two adjacent colors pixel-by-pixel at scale borders — classic retro texture without blur

**Form rules:**
- Body width: 4–6 pixels at 32px scale; taper tail to 1–2px
- Claws: 3-tine simplified at 32px; 5th claw only at 64px+
- Horns: 2px-wide branched antler in lighter highlight color to stand out from head
- Whiskers: single-pixel-wide diagonal or curved lines from snout

**Texture vocabulary:**
- Single highlight pixel on curved surface to sell 3D
- 2-color dither at the shadow/light terminator line
- Flat fills for large interior areas; selective detail at edges and feature points (head, claws, belly)

### Steampunk Fusion Elements

The design principle: **organic structure augmented by Victorian engineering.** The dragon's base anatomy is preserved; steampunk elements are grafted on as prosthetics or visible enhancements — it has been *fitted* with machinery, not replaced by it.

| Element | Placement | Pixel-art construction |
|---|---|---|
| Monocle / goggle | One eye | Circular ring (3px outer, 1px border), amber/sepia fill |
| Gear in mane | Spine or mane | Classic 8-tooth cog, readable at 8×8px |
| Riveted metal plate | One torso section | Rectangular outline + 4 corner dot-pixels as rivets |
| Piston arm | Leg joint | 2px-wide rectangle (cylinder) + rod extension |
| Exhaust vent | Nostrils or neck | Small rectangular chimney + 2px "smoke" puffs above |
| Clockwork panel | Underbelly section | "Window" in belly plate showing cogs inside |
| Brass banding | Horn mid-shaft | Lighter metallic horizontal stripe |

### SVG Pixel Art Techniques

**Each pixel as a rect:**
```xml
<svg viewBox="0 0 64 64" shape-rendering="crispEdges">
  <rect x="5" y="3" width="1" height="1" fill="#2E8B57"/>
</svg>
```

`shape-rendering="crispEdges"` is critical — without it, browsers anti-alias at scale, destroying the pixel aesthetic.

**CSS rendering (when SVG is used as image/background):**
```css
image-rendering: pixelated;   /* Chrome, Safari */
image-rendering: crisp-edges; /* Firefox */
```

**Grid discipline:**
- Integer coordinates only — no fractional values
- Paths: use only `H`, `V`, right-angle corners — no bezier curves
- Adjacent same-color pixels in same row → merge into one wider `<rect>` (reduces file size ~91%)

**Palette via `<defs>`:** Define strict hex set upfront; enforce limited palette at code level.

### Color Palettes

**Palette A — Jade and Brass (classic fusion)**

| Role | Hex |
|---|---|
| Dragon body dark | `#1A5C3A` |
| Dragon body mid | `#2E8B57` |
| Dragon highlight | `#7EC8A0` |
| Underbelly | `#F5EDD6` |
| Metal / gear (brass) | `#B5860D` |
| Metal highlight | `#D4A017` |
| Metal shadow | `#7A5C00` |
| Rivet / detail (copper) | `#B87333` |
| Eye / pearl (amber) | `#FFBF00` |
| Shadow / background | `#1C1C1C` |

**Palette B — Gold and Copper (imperial warmth)**

| Role | Hex |
|---|---|
| Dragon body dark | `#8B3A00` |
| Dragon body mid | `#C8860A` |
| Dragon highlight | `#FFD700` |
| Underbelly | `#F2E0B0` |
| Gear / pipe (copper) | `#B87333` |
| Metal dark | `#7A4A20` |
| Steam / smoke | `#A89880` |
| Eye (ruby) | `#CC2200` |
| Outline / shadow | `#2A1800` |

**Palette C — Dark Teal and Amber (atmospheric)**

| Role | Hex |
|---|---|
| Dragon body dark | `#0D3D40` |
| Dragon body mid | `#1A6B70` |
| Dragon highlight | `#4ABFC4` |
| Underbelly | `#B0E0E6` |
| Gear / metal (amber) | `#FF8C00` |
| Metal dark | `#8B4500` |
| Rivet / accent | `#CC7722` |
| Steam | `#E8D8B8` |
| Eye | `#FFB000` |
| Deep shadow | `#061A1C` |

**Palette discipline:** Maximum 8–16 unique colors. Each color: exactly three tonal variants (dark/mid/highlight). No gradients — fake with 2-color dithering at boundaries.

### Circular Composition (Wax Seal Format)

A serpentine dragon is linear; a wax seal is circular. Solution: coiling.

**Canonical coil forms:**
- **C-coil** — body curves into a near-closed circle, head at one end, tail tucked back. Oldest form (Hongshan culture, ~4000–3000 BCE jade carvings). Cleanest for small formats.
- **1.5–2 spiral** — body loops once or twice, head at top-center or dead center. Standard Chinese decorative dragon in round frames.
- **Ouroboros** — tail in mouth, body forms the circular border itself, head fills the bottom. Makes the dragon double as the seal's outer ring.

**Layout guidelines for ~40–60mm seal:**
1. Head at visual upper-center or dead center, in 3/4 profile (never full frontal — profile reads better at small scale)
2. Body spirals around the head, filling the circular field — 1.5 to 2 full loops
3. Claws (2–4 visible) point outward toward the circle edge, like spokes — creates dynamic tension
4. Whiskers and mane extend radially outward, reinforcing the circular frame
5. Flaming pearl (if included) directly in front of the mouth at center or offset center
6. Negative space — avoid filling every pixel; seal needs breathing room to read when physically stamped
7. Line weight — minimum 2px at 32px grid (fine details collapse in embossed wax)

**Physical seal constraints:**
- No gradients, no half-tones — solid shapes and clean outlines only
- Test design as white-on-dark silhouette before finalizing: this is how it reads in actual wax
- Radial symmetry aids readability but slight asymmetry feels more alive

### Recommended Build Workflow

1. Start with 64×64 pixel grid in `viewBox="0 0 64 64"`
2. Block in coiled serpentine body silhouette first — C-coil or 1.5-spiral
3. Place head at upper-center; rough in antler horns, whiskers, mane
4. Add 2–4 visible claws pointing outward
5. Apply scale texture to mid-body only (full-body scales at 64px read as noise)
6. Overlay steampunk elements: one monocle, one gear in mane, piston at one leg joint, riveted plate on one torso section
7. Choose one palette (A, B, or C) — enforce strictly, max 12 hex values
8. Export SVG with `shape-rendering="crispEdges"`, integer coordinates, merged same-color rects
9. Validate as white-on-black silhouette for seal readability

### Sources

- [Eastern Dragon Anatomy — The Circle of the Dragon](http://www.blackdrago.com/science/anatomy_east.htm)
- [Chinese dragon — Wikipedia](https://en.wikipedia.org/wiki/Chinese_dragon)
- [Asian Dragon Drawing Characteristics — Silver Ant Tattoo](https://silveranttattoo.com/asian-dragon-drawing-and-its-unique-characteristics-in-eastern-art-93dn.html)
- [Designing a Dragon-Themed Character — CLIP Studio](https://www.clipstudio.net/how-to-draw/archives/156714)
- [Dragon Scales Tutorial — Etherington Brothers, DeviantArt](https://www.deviantart.com/etheringtonbrothers/art/BRAND-NEW-TUTORIAL-How-to-draw-DRAGON-SCALES-903083785)
- [Dragon Scales Tutorial — ValsparinDragon, DeviantArt](https://www.deviantart.com/valsparindragon/art/TUTORIAL-Dragon-scales-558405884)
- [How to Make a Pixel Art Dragon — Mega Voxels](https://www.megavoxels.com/learn/how-to-make-a-pixel-art-dragon/)
- [shape-rendering — MDN SVG Reference](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/shape-rendering)
- [Crisp Pixel Art Look — MDN Web Docs](https://developer.mozilla.org/en-US/docs/Games/Techniques/Crisp_pixel_art_look)
- [Steampunk Dragons: Fantasy + Retrofuturism — SteampunkTribune](https://steampunktribune.com/steampunk-dragons/)
- [Steampunk Color Palette — Artsydee](https://www.artsydee.com/steampunk-colour-palette/)
- [Steampunk Colors — Steampunk Explorer](https://steampunk-explorer.com/articles/colors-steampunk)
- [Circular Coiled Dragon — Smithsonian / National Museum of Asian Art](https://asia.si.edu/explore-art-culture/collections/search/edanmdm:fsg_F1939.7/)
- [How to Design a Wax Seal From Scratch — Creative Market Blog](https://creativemarket.com/blog/how-to-design-a-wax-seal)

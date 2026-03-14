# Style Guide — Steampunk Metal

## Visual Direction

The UI follows a **steampunk industrial** aesthetic: aged metals, embossed plates, riveted surfaces, gas-lamp warmth. Avoid neon glows, saturated colors, or flat/digital-looking surfaces.

## Color Palette

### Global Tokens (CSS custom properties in `Layout.astro`)

| Token             | Value     | Usage                  |
|-------------------|-----------|------------------------|
| `--bg-darkest`    | `#0d0d14` | Page background        |
| `--bg-surface`    | `#1e1812` | Card / panel surface   |
| `--brass-primary` | `#c9a84c` | Primary brass accent   |
| `--brass-bright`  | `#d4a017` | Bright brass highlight |
| `--text-heading`  | `#f5e6c8` | Heading text (cream)   |
| `--text-primary`  | `#ccaa66` | Body text (muted brass)|
| `--text-muted`    | `#8a8a96` | Secondary text (gray)  |
| `--copper`        | `#b87333` | Links / tertiary accent|

### Project Accent Colors (metal tones, not hues)

Each project card uses a distinct **metal type** as its accent. These should read as metal, not as color:

| Project           | Hex       | Metal Reference       |
|-------------------|-----------|-----------------------|
| Cerebro Externo   | `#5a6b72` | Blued steel           |
| Forge Mentor      | `#8a7a3a` | Tarnished brass       |
| Entrepreneurity   | `#7a4a3a` | Aged copper           |

Defined in `apps/web-sirgrimorum/src/i18n/translations.ts` → `PROJECT_META[].accent`.

## Card Design — Embossed Metal Plate

Cards are styled to look like riveted metal plates. Key techniques:

### Beveled Border (emboss illusion)

Top/left borders use a lighter mix of the accent (light-catch side), right/bottom use a darker mix (shadow side):

```
border-top-color:    color-mix(in srgb, var(--accent) 55%, white)
border-left-color:   color-mix(in srgb, var(--accent) 45%, white)
border-right-color:  color-mix(in srgb, var(--accent) 60%, black)
border-bottom-color: color-mix(in srgb, var(--accent) 70%, black)
```

### Inset Shadows (plate depth)

- Inner top: bright highlight — `inset 0 1px 2px color-mix(... 25%, white)`
- Inner bottom: deep shadow — `inset 0 -2px 4px rgba(0,0,0,0.5)`

### Drop Shadow (plate sits on surface)

Two-layer outer shadow for natural depth:
- `0 4px 8px rgba(0,0,0,0.5)` — primary
- `0 1px 3px rgba(0,0,0,0.3)` — contact

### Hover — Plate Lift

On hover the card lifts with `translateY(-3px)` and the drop shadow deepens (8px 20px spread), plus a subtle warm glow around the edges.

### 3D Rivet Nail Heads (corners)

Four corner dots use a multi-stop `radial-gradient` to simulate rounded nail heads:

1. **Bright center** — `color-mix(accent 50%, white)` at 0px (highlight)
2. **Metal body** — `var(--accent)` at 2.5px
3. **Dark rim** — `color-mix(accent 40%, black)` at 4px
4. **Cutoff** — `transparent` at 5px

Positioned 10px from each corner edge.

## Buttons / Links — Small Embossed Plates

Buttons and action links reuse the same embossed metal plate treatment at a smaller scale. Default metal is `--brass-primary`.

### Structure

Same beveled border + inset shadows as cards, scaled down:
- `border-radius: 4px` (vs 6px on cards)
- Smaller drop shadow (`0 3px 6px`)
- Padding: `0.625rem 2.25rem` to leave room for side rivets

### Side Rivets

Two rivet nail heads — one on each side of the text — using the same multi-stop `radial-gradient`, scaled to 3.5px cutoff (vs 5px on cards). Positioned vertically centered at `8px` / `calc(100% - 8px)` horizontally.

### Interaction States

| State    | Effect |
|----------|--------|
| Hover    | `translateY(-2px)`, deeper drop shadow, subtle warm glow |
| Active   | `translateY(1px)`, inverted shadows (pressed-in plate) |

The `:active` pressed state is important — it makes the button feel like a physical mechanism being pushed.

### Reference

See `apps/web-sirgrimorum/src/pages/404.astro` → `.home-link` for the canonical implementation.

## Typography

| Usage      | Font Family              | Weight |
|------------|--------------------------|--------|
| Card title | Silkscreen               | 400    |
| Body / UI  | IBM Plex Mono            | 400/500|
| Pixel text | Press Start 2P           | 400    |

## Principles

1. **Metal, not color** — accents should evoke a specific metal alloy, not a saturated hue.
2. **Physical depth** — use beveled borders, inset shadows, and drop shadows to make surfaces feel tangible.
3. **Warm light source** — highlights mix toward white from top-left; shadows deepen toward bottom-right.
4. **Restraint on glow** — subtle warm glow on hover only; never neon bloom.

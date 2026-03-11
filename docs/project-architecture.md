# Project Architecture — Sirgrimorum

## Overview

Static single-page site. No framework, no build step, no server-side logic.

```
sirgrimorum.com/
  index.html    # Full page: inline CSS + Google Fonts + semantic HTML
  CNAME         # GitHub Pages custom domain: "sirgrimorum.com"
```

## Hosting

**GitHub Pages** — repo `sirgrimorum/sirgrimorum.com`, deployed from `main` branch root.
DNS via Cloudflare (A records → GitHub Pages IPs, proxied = false). GitHub handles HTTPS via Let's Encrypt.

## Design System

Steampunk pixel art theme. Tokens sourced from `packages/web-ui/src/css/tokens.css` in the monorepo; inline in `index.html` as CSS custom properties.

| Token | Value | Usage |
| ----- | ----- | ----- |
| `bg-darkest` | `#0D0D14` | Page background |
| `bg-surface` | `#1E1812` | Card panels |
| `brass-primary` | `#C9A84C` | Borders, interactive |
| `brass-bright` | `#D4A017` | CTAs, active states |
| `text-heading` | `#F5E6C8` | Headings |
| `text-primary` | `#CCAA66` | Body text |
| `copper` | `#B87333` | Links |

Fonts (Google Fonts, OFL): `Press Start 2P` (hero/pixel accents), `Silkscreen` (section headings), `IBM Plex Mono` (body).

## Page Structure

1. **Hero** — pixel gear icon, SIRGRIMORUM title, tagline.
2. **Project cards** (×3) — pixel-bordered panels for Cerebro Externo, Forge Mentor, Entrepreneurity.
3. **Footer** — `© 2026 sirgrimorum`.

Each card: product name (Silkscreen, accent glow), one-line tagline (IBM Plex Mono), status badge (Alpha / Coming Soon), link to product site.

## Layering Principles

- No JavaScript required. Pure HTML + CSS.
- `image-rendering: pixelated` on pixel art assets; `font-smooth: never` on pixel fonts.
- Single column layout, `max-width: 800px`, responsive.
- No external runtime dependencies beyond Google Fonts CDN.

## Delivery Targets

- Each increment should produce a visible, functional page (no half-built states in production).
- Foundation increment first: GitHub Pages + DNS + HTTPS.
- Feature increment: full styled page with all 3 cards.

## Infrastructure Note

No Terraform or CDK needed for this project. GitHub Pages handles hosting and TLS.
DNS records (A records for GitHub Pages + Resend SPF/DKIM/DMARC) both live in the same Cloudflare zone and are independent.

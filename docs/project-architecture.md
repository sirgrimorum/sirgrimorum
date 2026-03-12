# Project Architecture — Sirgrimorum

## Overview

Static single-page site. No framework, no build step, no server-side logic.

```
sirgrimorum/
  apps/
    web-sirgrimorum/
      index.html    # Full page: inline CSS + Google Fonts + semantic HTML
  infra/
    terraform/      # S3, ACM, Cloudflare DNS, GitHub OIDC IAM
    cdk/            # CloudFront distribution + S3 OAC
  .github/
    workflows/
      deploy.yml    # S3 sync + CloudFront invalidation on push to main
```

## Hosting

**S3 + CloudFront** — separate AWS org account (not brain-mcp account).
DNS via Cloudflare (CNAME → CloudFront distribution, proxied = false). CloudFront handles HTTPS via ACM.

Pattern identical to `../brain-mcp/infra/` — see that repo for reference.

### Infrastructure split

| Layer | Tool | What it creates |
| ----- | ---- | --------------- |
| DNS + certs + bucket + IAM | Terraform | ACM certs, Cloudflare DNS records, S3 marketing bucket, GitHub OIDC role |
| CloudFront | CDK | Distribution + S3 OAC |
| Content deploy | GitHub Actions | `aws s3 sync` + CF invalidation |

### Two-phase deploy

Terraform and CDK have a circular dependency (CDK needs bucket ARN from Terraform; Terraform needs CloudFront ARN for OAC policy + CNAME):

1. **Terraform phase 1** — bucket, certs, DNS validation records (leave CF vars empty)
2. **CDK deploy** — distribution; note domain + ARN from outputs
3. **Terraform phase 2** — populate `cloudfront_distribution_domain` + `marketing_cloudfront_distribution_arn` in `prod.tfvars`, apply to create CNAMEs + bucket policy

## Design System

Steampunk pixel art theme. Tokens sourced from `packages/web-ui/src/css/tokens.css` in the brain-mcp monorepo; inline in `index.html` as CSS custom properties.

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
- Foundation increment first: Terraform + CDK infra + DNS + HTTPS.
- Feature increment: full styled page with all 3 cards deployed via GHA.

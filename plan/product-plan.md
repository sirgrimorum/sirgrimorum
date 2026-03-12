# Product Plan — Sirgrimorum Landing Page

> Full detail in [`plan/sirgrimorum-landing.md`](sirgrimorum-landing.md).

## Goal

Ship a minimal static landing page at `sirgrimorum.com` that:
- Gives the sending domain a real web presence (Resend email reputation).
- Links visitors to all three alpha projects with steampunk pixel art cards.
- Requires zero ongoing infrastructure cost or maintenance.

## Feature Milestones

1. **Landing page live** — Astro app (`apps/web-sirgrimorum/`) with steampunk pixel art theme, hero, 3 project cards, footer. Deployed via S3+CloudFront at `sirgrimorum.com`. *(static site scaffolded — pending infra)*
2. **DNS + HTTPS** — Cloudflare A records pointing to GitHub Pages IPs. HTTPS enforced. Coexists with Resend SPF/DKIM/DMARC records.
3. **All three project cards** — Cerebro Externo (alpha), Forge Mentor (alpha), Entrepreneurity (coming soon). Each with name, tagline, status badge, and link.

## Foundation Milestones

1. **Resend migration deployed** *(prerequisite)* — `@sirgrimorum.com` sender domain verified in Resend before page is needed.
2. **GitHub Pages repo configured** — `sirgrimorum/sirgrimorum.com` repo, Pages enabled, custom domain set, HTTPS enforced.

## Feature Flags Strategy

Not applicable — static page with no runtime logic or flag-gated features.

## Risks

- **Resend migration is a hard prerequisite** — landing page is only needed once Resend sends from `@sirgrimorum.com`. No urgency before that.
- **DNS propagation delay** — A record changes can take up to 48 h. Set low TTL in Cloudflare before switching.
- **Design token drift** — tokens are defined in `packages/web-ui/src/css/tokens.css` in the monorepo. Keep inline styles in `index.html` aligned manually if those tokens change.

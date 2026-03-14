# Product Plan — Sirgrimorum Landing Page

> Full detail in [`plan/sirgrimorum-landing.md`](sirgrimorum-landing.md).

## Goal

Ship a minimal static landing page at `sirgrimorum.com` that:
- Gives the sending domain a real web presence (Resend email reputation).
- Links visitors to all three alpha projects with steampunk pixel art cards.
- Requires zero ongoing infrastructure cost or maintenance.

## Feature Milestones

1. **Landing page live** ✅ — Astro app (`apps/web-sirgrimorum/`) with steampunk pixel art theme, hero, 3 project cards, footer. Deployed via S3+CloudFront at `sirgrimorum.com`.
2. **DNS + HTTPS** ✅ — Cloudflare CNAME records pointing to CloudFront distribution. HTTPS enforced via ACM cert. Coexists with Resend SPF/DKIM/DMARC records.
3. **All three project cards** ✅ — Cerebro Externo (alpha), Forge Mentor (alpha), Entrepreneurity (coming soon). Each with name, tagline, status badge, and link.
4. **Localization** ✅ — English (default `/`), Spanish (`/es/`), Brazilian Portuguese (`/pt-br/`) via Astro i18n routing.

## Foundation Milestones

1. **Resend migration deployed** ✅ — `@sirgrimorum.com` sender domain verified in Resend.
2. **S3 + CloudFront infra** ✅ — Terraform (S3, ACM, Cloudflare DNS, IAM OIDC, budget) + CDK (CloudFront distribution + OAC) deployed to separate AWS org account.
3. **CI/CD pipeline** ✅ — GitHub Actions deploy on push to `main` (Astro build → S3 sync → CloudFront invalidation, OIDC auth).

## Feature Flags Strategy

Not applicable — static page with no runtime logic or flag-gated features.

## Risks

- **Resend migration is a hard prerequisite** — landing page is only needed once Resend sends from `@sirgrimorum.com`. *(Resolved — domain verified.)*
- **DNS propagation delay** — A record changes can take up to 48 h. Set low TTL in Cloudflare before switching. *(Resolved — CNAMEs propagated.)*
- **Design token drift** — tokens are defined in `packages/web-ui/src/css/tokens.css` in the monorepo. Keep inline styles in `index.html` aligned manually if those tokens change.

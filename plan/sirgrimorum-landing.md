# Plan: sirgrimorum.com Landing Page

> Minimal personal portfolio site at sirgrimorum.com using the steampunk pixel art
> design system. Links to three alpha projects. Supports email sender reputation
> for Resend (brain/mentor waitlist emails sent from `@sirgrimorum.com`).

**Status**: Deployed

**Decisions**:
- Framework: Astro (static output, no client JS, component model for future reuse)
- Hosting: S3 + CloudFront (separate AWS org account)
- ✅ Resend `@sirgrimorum.com` sender domain verified
- ✅ Static site scaffolded (`apps/web-sirgrimorum/`)
- ✅ Terraform infra deployed (S3, ACM, IAM OIDC, Cloudflare DNS, budget alerts)
- ✅ CDK CloudFront distribution deployed (E2GG0KR8IYR869)
- ✅ DNS CNAMEs + OAC bucket policy applied
- ✅ Content deployed to S3 + CloudFront invalidated
- ✅ Site live at https://sirgrimorum.com

**Hosting decision**: Option A — S3 + CloudFront (separate AWS org account, same pattern as brain-mcp / vitalidad)

---

## Purpose

1. **Sender reputation**: Gmail/Yahoo check if the sending domain has a real
   web presence. A landing page at `sirgrimorum.com` prevents the domain from
   looking abandoned/suspicious.
2. **Project hub**: Single page linking to all three alpha projects.
3. **Personal branding**: Lightweight portfolio presence.

## Design

### Visual Style

Steampunk pixel art theme — same design system as brain4ai.app and mentor4ai.app.

**Key tokens** (from `packages/web-ui/src/css/tokens.css`):

| Token            | Value      | Usage                     |
| ---------------- | ---------- | ------------------------- |
| `bg-darkest`     | `#0D0D14`  | Page background           |
| `bg-surface`     | `#1E1812`  | Card panels               |
| `brass-primary`  | `#C9A84C`  | Borders, interactive      |
| `brass-bright`   | `#D4A017`  | CTAs, active states       |
| `text-heading`   | `#F5E6C8`  | Headings                  |
| `text-primary`   | `#CCAA66`  | Body text                 |
| `text-muted`     | `#8A8A96`  | Labels, captions          |
| `copper`         | `#B87333`  | Links                     |

**Typography**:

- `Press Start 2P` — hero title, pixel accent text
- `Silkscreen` — section headings
- `IBM Plex Mono` — body text (readable, not pixelated)
- All from Google Fonts (OFL licensed)

**Layout**: Single page, dark background, centered content (max-width 800px).

### Content Structure

```
┌─────────────────────────────────────────┐
│  [pixel gear icon]                      │
│                                         │
│  SIRGRIMORUM                            │
│  Building tools for thinkers            │
│  and builders.                          │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────┐  Product card colors:  │
│  │ CEREBRO     │  brain-primary #5A9ABE │
│  │ EXTERNO     │  (blueprint blue)      │
│  │             │                        │
│  │ Your AI     │                        │
│  │ external    │                        │
│  │ brain.      │                        │
│  │             │                        │
│  │ [alpha]     │                        │
│  │ brain4ai.app│                        │
│  └─────────────┘                        │
│                                         │
│  ┌─────────────┐  mentor-primary        │
│  │ FORGE       │  #E8A317               │
│  │ MENTOR      │  (furnace amber)       │
│  │             │                        │
│  │ AI mentor   │                        │
│  │ for startup │                        │
│  │ builders.   │                        │
│  │             │                        │
│  │ [alpha]     │                        │
│  │ mentor4ai.  │                        │
│  │ app         │                        │
│  └─────────────┘                        │
│                                         │
│  ┌─────────────┐  danger #C0392B or     │
│  │ ENTREPRE-   │  custom game color     │
│  │ NEURIT-Y    │  (furnace red/orange)  │
│  │             │                        │
│  │ Learn       │                        │
│  │ business    │                        │
│  │ strategy    │                        │
│  │ by playing. │                        │
│  │             │                        │
│  │ [coming     │                        │
│  │  soon]      │                        │
│  │ entrepre-   │                        │
│  │ neurit-y.app│                        │
│  └─────────────┘                        │
│                                         │
├─────────────────────────────────────────┤
│  © 2026 sirgrimorum                     │
└─────────────────────────────────────────┘
```

Each card is a pixel-bordered panel with:

- Product name in `Silkscreen` (product accent color glow)
- One-line description in `IBM Plex Mono`
- Status badge (`[alpha]` or `[coming soon]`) — pixel-style pill
- Link to the product site

### Localization

**In scope from v1.** Three locales: English (default), Spanish, Brazilian Portuguese.

| Locale | URL | html[lang] |
| ------ | --- | ---------- |
| en (default) | `/` | `en` |
| es | `/es/` | `es` |
| pt-br | `/pt-br/` | `pt-BR` |

**Implementation:**
- Astro built-in i18n routing (`prefixDefaultLocale: false`)
- `src/i18n/translations.ts` — single file, all strings for all locales, type-safe
- `src/components/HomePage.astro` — shared page template, takes `locale` prop
- Three thin page wrappers: `pages/index.astro`, `pages/es/index.astro`, `pages/pt-br/index.astro`
- `src/components/LanguagePicker.astro` — locale switcher in hero, uses `getRelativeLocaleUrl`
- hreflang tags on all pages (en, es, pt-BR, x-default) via `getAbsoluteLocaleUrl`

---

## Do You Need a Mailbox?

**No.** None of the domains need to receive email:

| Concern | How it's handled |
| ------- | ---------------- |
| Sending | Resend API (no mailbox) |
| Replies | `reply-to: sirgrimorum+brain@gmail.com` (Gmail) |
| Bounces | Resend webhook → `POST /waitlist/webhooks/resend` |
| Unsubscribe | HTTP endpoint → `GET/POST /waitlist/unsubscribe` |
| DMARC reports | `rua=mailto:sirgrimorum+dmarc@gmail.com` (optional, goes to Gmail) |

Gmail's `+` addressing routes all replies to your existing inbox with no setup.

---

## Infrastructure

**Selected: Option A — S3 + CloudFront**

This repo (`sirgrimorum`) is its own monorepo with its own Terraform + CDK setup,
deployed to a separate AWS account within the same organization.
Reference pattern: `../brain-mcp/infra/`.

---

### Repo structure to create

```
sirgrimorum/
  apps/
    web-sirgrimorum/
      index.html          # Full static page — no build step
  infra/
    terraform/
      backend.tf
      main.tf
      variables.tf
      outputs.tf
      versions.tf
      environments/
        prod.tfvars
      modules/
        dns/              # ACM certs + Cloudflare CNAME records (same as brain-mcp)
        storage/          # Marketing S3 bucket only (no DynamoDB, no ECR)
        iam/              # GitHub OIDC role for GHA deploy
        budget/           # Optional budget alert
    cdk/
      bin/
        app.ts
      lib/
        cloudfront-stack.ts   # One CloudFront distribution + S3 OAC
        config.ts
      cdk.json
      package.json
      tsconfig.json
  .github/
    workflows/
      deploy.yml          # S3 sync + CloudFront invalidation on push to main
```

---

### Terraform modules

Simpler than brain-mcp — no networking, no DynamoDB, no ECR.

**`modules/dns/`** — identical to brain-mcp:
- Cloudflare zone data source for `sirgrimorum.com`
- ACM cert (regional, us-east-1 for CloudFront), wildcard SAN
- ACM DNS validation via Cloudflare CNAME
- Cloudflare CNAME records → CloudFront distribution domains (populated after CDK deploy)

**`modules/storage/`** — one marketing bucket only:
- `sirgrimorum-prod-marketing` (private, AES256 SSE, public access blocked)
- OAC bucket policy: allows CloudFront distribution ARN (populated after CDK deploy)
- Bucket naming: `sirgrimorum-{environment}-marketing`

**`modules/iam/`** — GitHub OIDC role:
- OIDC provider (or import if org-level provider exists)
- Role: `sirgrimorum-prod-github-deploy`, trust `repo:sirgrimorum/sirgrimorum:ref:refs/heads/main`
- Policy: `s3:PutObject`, `s3:DeleteObject`, `s3:ListBucket` on marketing bucket + `cloudfront:CreateInvalidation`

**`environments/prod.tfvars`**:
```hcl
environment = "prod"
region      = "us-east-1"
domain      = "sirgrimorum.com"
github_org  = "sirgrimorum"
github_repo = "sirgrimorum"

# Populated after CDK deploy:
cloudfront_distribution_domain = ""

# Populated after CDK deploy:
marketing_cloudfront_distribution_arn = ""

budget_limit       = 1
budget_alert_email = "sirgrimorum+sirgrimorum@gmail.com"
create_budgets     = false   # linked account — enable after payer activates
```

---

### CDK stack

**`lib/cloudfront-stack.ts`** — simplified from brain-mcp (no API Gateway origins):

- Import marketing S3 bucket from Terraform outputs (bucket name + ARN from CDK context)
- Import CloudFront ACM cert (us-east-1 ARN from Terraform outputs)
- Single `S3OriginAccessControl` OAC
- One `cloudfront.Distribution`:
  - `domainNames: ["sirgrimorum.com", "www.sirgrimorum.com"]`
  - S3 OAC origin
  - `defaultRootObject: "index.html"`
  - `REDIRECT_TO_HTTPS`
  - www-redirect CloudFront Function (same inline function as brain-mcp — no `.html` rewrite needed, single-page site)
  - 403/404 → `/index.html` (single page, no 404.html needed)

**CDK context** (`cdk.json`) holds Terraform output references, same pattern as brain-mcp.

---

### GitHub Actions — `deploy.yml`

```yaml
on:
  push:
    branches: [main]
    paths:
      - "apps/web-sirgrimorum/**"
  workflow_dispatch:

permissions:
  contents: read
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1
      - name: Deploy to S3
        run: |
          aws s3 sync apps/web-sirgrimorum/ s3://${{ vars.MARKETING_S3_BUCKET }} --delete
          aws cloudfront create-invalidation \
            --distribution-id ${{ vars.CF_DISTRIBUTION_ID }} \
            --paths "/*"
```

No build step — `index.html` is synced directly.

---

### Two-phase deploy sequence

1. **Terraform apply (phase 1)**
   - Creates S3 bucket, ACM certs, Cloudflare ACM validation records
   - Leave `cloudfront_distribution_domain` and `marketing_cloudfront_distribution_arn` empty

2. **CDK deploy**
   - `cdk deploy` with context pointing to Terraform outputs
   - Outputs: CloudFront distribution domain + ARN

3. **Terraform apply (phase 2)**
   - Populate `cloudfront_distribution_domain` and `marketing_cloudfront_distribution_arn` in `prod.tfvars`
   - Creates Cloudflare CNAME records (`sirgrimorum.com` + `www.sirgrimorum.com` → CloudFront)
   - Applies OAC bucket policy

4. **First content deploy**
   - `aws s3 sync apps/web-sirgrimorum/ s3://sirgrimorum-prod-marketing --delete`
   - `aws cloudfront create-invalidation --distribution-id EXXXXXX --paths "/*"`
   - Or trigger via GitHub Actions `workflow_dispatch`

---

## Implementation Steps

### 1. Create the static site ✅ (done)

```
apps/web-sirgrimorum/
  src/
    layouts/Layout.astro        # Google Fonts, CSS tokens (custom properties), global styles
    components/ProjectCard.astro # name, tagline, badge, link — scoped styles
    pages/index.astro           # Hero + 3 project cards + footer
  astro.config.mjs              # output: static, site: https://sirgrimorum.com
  package.json
  tsconfig.json
```

Build output: `apps/web-sirgrimorum/dist/` (pure HTML+CSS, no client JS).
Deploy: `aws s3 sync apps/web-sirgrimorum/dist/ s3://<bucket>` (see `deploy.yml`).

### 2. Bootstrap Terraform ✅ (done)

```bash
cd infra/terraform

# Init with S3 backend (new bucket in sirgrimorum AWS account)
terraform init

# Phase 1: creates S3 bucket, ACM certs, Cloudflare validation records
terraform apply -var-file=environments/prod.tfvars
```

### 3. CDK deploy ✅ (done)

```bash
cd infra/cdk
npm install
npx cdk deploy -c sirgrimorum:env=prod
# Note CloudFront distribution domain + ARN from outputs
```

### 4. Terraform phase 2 ✅ (done)

Populate `cloudfront_distribution_domain` and `marketing_cloudfront_distribution_arn`
in `environments/prod.tfvars` from CDK outputs, then:

```bash
terraform apply -var-file=environments/prod.tfvars
# Creates Cloudflare CNAMEs + OAC bucket policy
```

### 5. Deploy content ✅ (done)

```bash
aws s3 sync apps/web-sirgrimorum/ s3://sirgrimorum-prod-marketing --delete
aws cloudfront create-invalidation --distribution-id EXXXXXX --paths "/*"
```

Or trigger via `workflow_dispatch` on `deploy.yml`.

### 6. Verify ✅ (done)

- `curl -I https://sirgrimorum.com` → 200 OK
- Page renders with steampunk theme
- All 3 project links work
- Resend domain verification still passes (DNS records are independent)

---

## Project Card Content

### Cerebro Externo (Brain4AI)

- **Name**: Cerebro Externo
- **Tagline**: Your AI external brain.
- **Description**: Extracts your expertise through conversations and organizes it as a library your AI always has at hand.
- **Status**: Alpha
- **URL**: https://brain4ai.app
- **Accent**: `#5A9ABE` (blueprint blue)

### Forge Mentor (Mentor4AI)

- **Name**: Forge Mentor
- **Tagline**: AI mentor for startup builders.
- **Description**: An AI mentor forged from 10+ years of startup acceleration that tells you what to do today, not another framework.
- **Status**: Alpha
- **URL**: https://mentor4ai.app
- **Accent**: `#E8A317` (furnace amber)

### Entrepreneurity

- **Name**: Entrepreneurity
- **Tagline**: Learn business strategy by playing.
- **Description**: A steampunk strategy game where you build and operate a business in living markets. Design experiments, face market waves, analyze results, adapt or die.
- **Genre**: Strategic simulation with tower defense mechanics (endless roguelike)
- **Status**: Coming Soon
- **URL**: https://entrepreneurity.app
- **Accent**: `#C0392B` (steam valve red) — or a custom game-specific color
- **Reference**: `../vitalidad/plan/juego-td-negocios-gdd.md`

---

## Future Considerations

- **Phase 4 (public launch)**: Migrate email sending from `@sirgrimorum.com` to
  `@brain4ai.app` / `@mentor4ai.app` (Resend Pro, unlimited domains).
- **Portfolio growth**: If more projects are added, consider migrating to
  Option A (S3 + CloudFront in the monorepo pipeline).
- **Analytics**: Add PostHog snippet if you want to track visits (same key
  as marketing sites).

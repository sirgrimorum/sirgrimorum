# Plan: sirgrimorum.com Landing Page

> Minimal personal portfolio site at sirgrimorum.com using the steampunk pixel art
> design system. Links to three alpha projects. Supports email sender reputation
> for Resend (brain/mentor waitlist emails sent from `@sirgrimorum.com`).

**Status**: Pending (prerequisite: Resend migration deployed)

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

**Not needed for v1.** English only. The product sites handle their own i18n.

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

### Option A: S3 + CloudFront (recommended — matches existing pattern)

Reuse the same infra pattern as brain4ai.app / mentor4ai.app marketing sites.

#### Terraform changes

1. Add `sirgrimorum.com` to the `domains` list in `staging.tfvars`:

```hcl
domains = ["brain4ai.app", "mentor4ai.app", "sirgrimorum.com"]
```

2. This automatically creates:
   - Cloudflare zone lookup
   - ACM certs (regional + CloudFront wildcard)
   - ACM DNS validation records in Cloudflare

3. Add a marketing bucket for sirgrimorum.com in the storage module
   (same pattern as existing marketing buckets).

4. After CDK deploy, add the CloudFront distribution domain to
   `cloudfront_distribution_domains` in `staging.tfvars`.

#### CDK changes

Add a CloudFront distribution + S3 OAC for `sirgrimorum.com` in the
CloudFront stack (same pattern as brain4ai/mentor4ai marketing distros).

#### Deployment

Same as existing marketing sites:

```bash
# Build the static site
cd apps/web-sirgrimorum && pnpm build

# Deploy to S3 + invalidate CloudFront
aws s3 sync out/ s3://brain-mcp-staging-marketing-sirgrimorum-com/ --delete
aws cloudfront create-invalidation --distribution-id EXXXXXX --paths "/*"
```

Or add to the existing `deploy-marketing.yml` GitHub Actions workflow.

### Option B: GitHub Pages (zero cost, zero infra)

If you want to avoid any AWS cost/complexity:

1. Create a repo `sirgrimorum/sirgrimorum.com` (or use existing)
2. Single `index.html` with inline CSS (steampunk theme)
3. Enable GitHub Pages → custom domain `sirgrimorum.com`
4. Add Cloudflare DNS: `sirgrimorum.com` CNAME → `sirgrimorum.github.io`
5. GitHub handles HTTPS via Let's Encrypt

**Pros**: Zero cost, no S3/CloudFront overhead, 5-minute setup.
**Cons**: Not in the monorepo deploy pipeline, separate repo.

### Recommendation

**Option B (GitHub Pages)** for now — this is a single static HTML page with
no build step needed. You can always migrate to Option A later if the site
grows or you want it in the monorepo pipeline.

---

## Implementation Steps

### 1. Create the static site

Single `index.html` file with inline styles (no build system needed):

```
sirgrimorum.com/
  index.html      # Full page with inline CSS + Google Fonts
  CNAME           # GitHub Pages custom domain file: "sirgrimorum.com"
```

**HTML structure:**

- `<head>`: Google Fonts (Press Start 2P, Silkscreen, IBM Plex Mono), meta tags, inline `<style>`
- `<body>`: Hero section + 3 project cards + footer
- No JavaScript required (pure HTML+CSS)
- Responsive: single column, max-width 800px
- `image-rendering: pixelated` on pixel art assets
- Pixel fonts at integer sizes, `font-smooth: never`

### 2. DNS setup (Cloudflare)

**For GitHub Pages:**

```
sirgrimorum.com    A       185.199.108.153
sirgrimorum.com    A       185.199.109.153
sirgrimorum.com    A       185.199.110.153
sirgrimorum.com    A       185.199.111.153
www.sirgrimorum.com CNAME  sirgrimorum.github.io
```

Set `proxied = false` (DNS-only) — GitHub Pages handles HTTPS.

**These are separate from the Resend DNS records** (SPF/DKIM/DMARC).
Both sets coexist in the same Cloudflare zone.

### 3. GitHub Pages setup

```bash
# Create repo (or use existing)
gh repo create sirgrimorum/sirgrimorum.com --public

# Add the static site
echo "sirgrimorum.com" > CNAME
# ... create index.html ...
git add . && git commit -m "Initial landing page"
git push origin main

# Enable GitHub Pages in repo settings:
# Settings → Pages → Source: Deploy from branch (main, / root)
# Custom domain: sirgrimorum.com → Enforce HTTPS ✅
```

### 4. Verify

- `curl -I https://sirgrimorum.com` → 200 OK
- Check the page renders with steampunk theme
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

# Feature Roadmap

## Feature: Sirgrimorum Landing Page ✅

**Status**: Shipped

### User Capability

Visitors to `sirgrimorum.com` see a steampunk pixel art landing page with:
- Hero section with brand identity
- Three project cards (Cerebro Externo, Forge Mentor, Entrepreneurity) linking to their respective apps
- Language picker for English, Spanish, and Brazilian Portuguese
- Responsive layout

### Flag Strategy

Not applicable — static site, no feature flags.

### E2E Acceptance

- [x] `https://sirgrimorum.com` serves the landing page over HTTPS
- [x] All three project cards render with correct names, taglines, badges, and links
- [x] Language picker switches between `/`, `/es/`, `/pt-br/`
- [x] hreflang tags present on all pages
- [x] Resend domain verification still passes (DNS records coexist)

### Verification

- [x] Astro build succeeds (`npm run build`)
- [x] Site live at https://sirgrimorum.com

---

## Feature: Analytics Integration (future)

**Status**: Not started

### User Capability

Track page visits and engagement to understand traffic sources and project card click-through rates.

### Flag Strategy

- Flag name: N/A — add PostHog snippet unconditionally
- Rollout phase: Single deploy

### E2E Acceptance

- [ ] PostHog events fire on page load
- [ ] Project card clicks tracked

### Verification

- [ ] PostHog dashboard shows events from `sirgrimorum.com`

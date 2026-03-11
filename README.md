# Sirgrimorum

Personal portfolio hub at [sirgrimorum.com](https://sirgrimorum.com) — steampunk pixel art landing page linking to three alpha projects, and the sending domain for Resend-based waitlist emails.

## Purpose

1. **Sender reputation** — gives `@sirgrimorum.com` a real web presence so Gmail/Yahoo don't flag outbound waitlist emails as spam.
2. **Project hub** — single page with cards linking to Cerebro Externo, Forge Mentor, and Entrepreneurity.
3. **Personal branding** — lightweight portfolio presence.

## Projects Linked

| Project | URL | Status |
| ------- | --- | ------ |
| Cerebro Externo | [brain4ai.app](https://brain4ai.app) | Alpha |
| Forge Mentor | [mentor4ai.app](https://mentor4ai.app) | Alpha |
| Entrepreneurity | [entrepreneurity.app](https://entrepreneurity.app) | Coming Soon |

## Implementation

Single `index.html` + `CNAME` — no build step, no dependencies.
Deployed via **GitHub Pages** with custom domain `sirgrimorum.com`.

See [`plan/sirgrimorum-landing.md`](plan/sirgrimorum-landing.md) for full detail.

## Documentation

- [Project Architecture](docs/project-architecture.md)
- [Manual Setup](docs/manual-setup.md)
- [AI Development Guide](docs/ai-development-guide.md)

## AI Assistant Governance

- Canonical source of truth: [`AGENTS.md`](AGENTS.md)
- Governance skill: `skills/agent-governance/SKILL.md`

```bash
make agents-bootstrap   # Copy missing governance files
make agents-adapt       # Guidance for agent-driven adapt
make agents-finalize    # Guidance for agent-driven finalize before PR/commit
```

## Non-Negotiables

- Assistants do not commit unless explicitly requested.
- Plan-first: update `plan/` files as scope evolves.
- PR drafts under `prs/` before opening PRs.

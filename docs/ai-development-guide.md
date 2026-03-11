# AI Development Guide

AI development guide for the Sirgrimorum static landing page.

Keep this file updated with project-specific context (commands, structure, constraints) as the codebase evolves.

## Purpose

- Explain how assistants should work in this repo.
- Keep context loading efficient (canonical source + adapters).
- Define stable command interfaces and verification workflow.

## Canonical Context Model

1. `AGENTS.md` is source of truth.
2. Scoped `AGENTS.md` files refine local package/app constraints.
3. Agent-specific files are adapters (`CLAUDE.md`, `CODEX.md`, `.gemini/GEMINI.md`).
4. Deep references live in `docs/` and active plans in `plan/`.

## Suggested Assistant Workflow

1. Read relevant governance + architecture docs.
2. Inspect target files and surrounding patterns.
3. Apply minimal, contextual changes.
4. Run verification commands.
5. Update plan files and PR draft artifacts as needed.

## Project-Specific Context

- **Single file**: `index.html` + `CNAME`. No build step, no dependencies, no package manager.
- **Deployed via GitHub Pages** — push to `main` on `sirgrimorum/sirgrimorum.com` repo.
- **Design tokens** inline in `index.html` as CSS custom properties (sourced from monorepo `packages/web-ui/src/css/tokens.css`).
- **No JavaScript** — pure HTML + CSS only.
- **Active plan**: `plan/sirgrimorum-landing.md`.

## Command Interface

Prefer use-case commands in `Makefile`.

For this project (static HTML, no build tooling):

```bash
# Verify the page renders correctly — open index.html in a browser
make verify   # runs lint (HTML validation if configured)

# Governance
make agents-bootstrap
make agents-adapt
make agents-finalize
```

For agent-driven governance evolution (`adapt`, `upgrade`, `finalize`), use the governance skill workflow directly.

## Guardrails

- Keep code simple, readable, and performant.
- Avoid duplicated logic, magic numbers, and hardcoding.
- Keep business rules separated from UI rendering layers.
- Use contract-first boundaries where possible.
- Add tests + CI commands by default unless explicitly exempted.
- Keep `.env` sprawl minimized and config centralized.

## Maintenance Rule

Update this guide whenever any of these change:

- directory structure
- core make targets
- assistant governance model
- testing/CI workflow
- architecture boundaries

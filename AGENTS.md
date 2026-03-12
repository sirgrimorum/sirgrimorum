# AGENTS.md — Sirgrimorum

Canonical assistant source of truth for this repository.

## Project Context

**sirgrimorum.com** — static personal portfolio hub. Astro app (`apps/web-sirgrimorum/`) that builds to pure HTML+CSS. Deployed to S3+CloudFront via GitHub Actions. IaC: Terraform (DNS/certs/bucket/IAM) + CDK (CloudFront distribution).

- Design system: steampunk pixel art (tokens from `packages/web-ui/src/css/tokens.css` in the monorepo).
- Fonts: `Press Start 2P`, `Silkscreen`, `IBM Plex Mono` (Google Fonts, OFL).
- Links to: Cerebro Externo (brain4ai.app), Forge Mentor (mentor4ai.app), Entrepreneurity (entrepreneurity.app).
- Also serves as the sending domain for Resend waitlist emails (`@sirgrimorum.com`).

Active plan: [`plan/sirgrimorum-landing.md`](plan/sirgrimorum-landing.md).

## Canonical Hierarchy

1. This file (`AGENTS.md`) is authoritative.
2. Scoped `AGENTS.md` files in apps/packages refine local constraints.
3. Agent-specific files (`CLAUDE.md`, `CODEX.md`, `.gemini/GEMINI.md`) are adapters only.
4. Deep docs in `docs/` and active execution plans in `plan/` provide full detail.

## Core Engineering Principles

1. Architecture first, then implementation.
2. Code simplicity and performance over cleverness.
3. Reuse existing modules/patterns before creating new abstractions.
4. No duplicated logic, no magic numbers, minimal hardcoding.
5. Contract-first integration between layers and services.
6. Use well-known, supported, lightweight libraries where appropriate; ask for approval before introducing a new dependency; don't try to reinvent the wheel.
7. Use Mermaid for documentation diagrams; do not use ASCII-art diagrams.

## Delivery Model

1. Plan using two categories:
   - Feature plans: new user-visible capabilities.
   - Foundation plans: internal capabilities that unlock future features.
2. Every track should reach fully functional E2E behavior as early as feasible.
3. Every feature should include E2E feature-flag strategy (according to product stage and rollout plan).
4. Keep `.env` usage minimal; prefer typed config with safe defaults.
5. Keep business/method rules separated from UI rendering concerns.
6. Prefer a BFF/backend-in-frontend layer (or SSR server layer) to isolate orchestration logic from UI components.

## Ways of Working

1. Use-case command interface only (`make <target>`).
2. Add scripts behind `make` targets when workflows get repetitive.
3. Keep `docs/manual-setup.md` current with setup/build/test/run flows.
4. Keep `docs/art-direction/` present and enforceable from the start.
5. Add tests by default, plus CI commands for those tests (unless explicitly exempted).
6. Plan-first execution: update plan files as scope/decisions/status evolve.
7. Draft PR descriptions in `prs/<scope>.md` before opening PRs.
8. Remove worktrees after merge.
9. Assistants do not commit unless explicitly requested.

## Skill Command Interface

- Governance skill: `bootstrap`, `adapt`, `upgrade`, `finalize`
- Canonical instructions: `skills/agent-governance/SKILL.md`

| Agent           | Invocation                                                                                          |
| --------------- | --------------------------------------------------------------------------------------------------- |
| **Claude Code** | `/agent-governance` — interactive mode selection                                                    |
| **Codex CLI**   | Read `skills/agent-governance/SKILL.md`, pick a mode, follow the steps                              |
| **Gemini CLI**  | Read `skills/agent-governance/SKILL.md`, pick a mode, follow the steps                              |
| **Any agent**   | `make agents-bootstrap` (deterministic) or `make agents-adapt\|upgrade\|finalize` (prints guidance) |

## Infrastructure Policy

- IaC-first for anything automatable.
- Terraform owns foundation (network, DNS/certs, IAM baseline, observability skeleton).
- CDK owns application layer (compute, APIs, databases, storage, event pipelines).
- Manual steps are limited to account/bootstrap and external service dashboards.

## Read First

- `docs/ai-development-guide.md`
- `docs/project-architecture.md`
- `docs/branching-strategy.md`
- `docs/service-setup.md`
- `docs/manual-setup.md`
- Active plans in `plan/`
- Agent-agnostic rule source: `ai/rules/`
- Agent-agnostic hook source: `scripts/hooks/`

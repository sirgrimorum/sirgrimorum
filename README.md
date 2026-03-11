# Project Bootstrap Kit — AI Assistant System

Reusable starter files to replicate the Entrepreneurity operating model in a new repository.

## Design Principle

`AGENTS.md` is canonical and agent-agnostic. Other agent files are thin adapters.

## What This Kit Provides

- Canonical assistant governance (`AGENTS.md`)
- Agent adapters (`CLAUDE.md`, `CODEX.md`, `.gemini/GEMINI.md`, Copilot instructions)
- Agent skill compatibility via `make agents-*` targets
- Agent-agnostic rules source (`ai/rules/`)
- Agent-agnostic hook scripts (`scripts/hooks/`)
- Claude adapters for rules/hooks (`.claude/rules/`, `.claude/hooks/`)
- Use-case-oriented `Makefile`
- Branching/worktree and IaC ownership split docs
- Contract-first + BFF architecture guidance
- Feature/foundation planning templates (`plan/`)
- PR temp markdown workflow (`prs/`)
- Manual setup and art-direction documentation scaffolding
- Generic `docs/ai-development-guide.md` baseline for per-project updates

## Quick Start (new repo)

1. Copy this folder into the new repo root.
2. Replace placeholders (`<Project Name>`) and app/package paths.
3. Keep policy text in `AGENTS.md`; keep adapters minimal.
4. Adapt `Makefile` targets to real project commands.
5. Set up CI to run `make ci`.
6. Keep plans and manual guide current through implementation.

## Skill Companion

Use with the `agent-governance` skill in `skills/agent-governance/`.
The skill is self-contained: it includes its own template and references under `assets/` and `references/`.

Model:

- `bootstrap` is deterministic and script-driven.
- `adapt`, `upgrade`, and `finalize` are agent-driven workflows using skill context.

## Non-Negotiables

- IaC-first provisioning policy.
- Terraform foundation + CDK app-layer split.
- Feature/foundation planning with early E2E outcomes.
- Feature flags E2E for user-facing features (phase-aware).
- Tests + CI test commands by default.
- `.env` minimization and centralized config strategy.
- PR drafts under `prs/`, remove after merge.
- Worktree cleanup after merge.
- Assistants do not commit unless explicitly requested.

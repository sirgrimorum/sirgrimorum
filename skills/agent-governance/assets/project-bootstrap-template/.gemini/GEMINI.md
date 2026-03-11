# <Project Name> — Gemini Adapter

Gemini adapter file. Source of truth is `AGENTS.md`.

## Read First

@AGENTS.md
@docs/project-architecture.md
@docs/branching-strategy.md
@docs/service-setup.md
@docs/manual-setup.md

## Governance Skill

For governance operations (bootstrap, adapt, upgrade, finalize), read `skills/agent-governance/SKILL.md` and follow the mode-specific steps. Run `make agents-bootstrap` for deterministic bootstrap or `make agents-adapt|upgrade|finalize` for guidance.

## Gemini-Specific Highlights

- Use this file for minimal Gemini usage tips only.
- Keep policy definitions centralized in `AGENTS.md`.

# CODEX.md — Sirgrimorum

Codex adapter file. Source of truth is `AGENTS.md`.

## Read Order

1. `AGENTS.md`
2. Nearest scoped `AGENTS.md`
3. Relevant docs in `docs/` and active files in `plan/`

## Codex-Specific Highlights

- Keep implementation loops command-driven via `make` targets.
- Prefer concise context: inherit policy from `AGENTS.md`, add only Codex-specific behavior here.

## Governance Skill

For governance operations (bootstrap, adapt, upgrade, finalize), read `skills/agent-governance/SKILL.md` and follow the mode-specific steps. Run `make agents-bootstrap` for deterministic bootstrap or `make agents-adapt|upgrade|finalize` for guidance.

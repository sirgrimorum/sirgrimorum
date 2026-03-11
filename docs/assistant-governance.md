# Assistant Governance

## Canonical Source Model

- Canonical policy: `AGENTS.md`
- Scoped constraints: app/package `AGENTS.md`
- Agent adapters: `CLAUDE.md`, `CODEX.md`, `.gemini/GEMINI.md`, Copilot instructions
- Deep implementation docs: `docs/`
- Execution plans: `plan/`

## Agent-Agnostic Rules and Hooks

- Canonical rules live in `ai/rules/`
- Canonical hook scripts live in `scripts/hooks/`
- Agent-specific folders (for example `.claude/`) should reference or wrap canonical files

This prevents policy drift when using multiple assistants.

## Update Pattern

1. Update `AGENTS.md` first.
2. Update canonical `ai/rules/` / `scripts/hooks/` if needed.
3. Update agent adapters only for tool-specific behavior.
4. Update impacted scoped `AGENTS.md` files.
5. Update `docs/ai-development-guide.md` with current repo context.
6. Record changes in plan files.

## Delivery Governance

- Plans must be feature-based or foundation-based.
- Target E2E functionality as early as practical per track.
- User-facing features should define feature-flag rollout strategy.
- Keep business rules outside UI rendering layers (BFF/server-layer encouraged).
- Documentation diagrams must use Mermaid code blocks, not ASCII-art diagrams.
- Include tests and CI commands unless explicitly exempted.

## Operational Skill

- Use `agent-governance` for bootstrap/adapt/upgrade/finalize operations.
- Prefer `make agents-*` targets as the command interface.

## Commit Policy

Assistants leave commits to the user unless explicitly requested.

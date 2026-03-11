# CLAUDE.md — <Project Name>

Claude adapter file. Source of truth is `AGENTS.md`.

## Read Order

1. `AGENTS.md`
2. Nearest scoped `AGENTS.md`
3. Relevant docs in `docs/` and active files in `plan/`

## Claude-Specific Highlights

- Use `.claude/rules/*` as adapters to canonical rules in `ai/rules/*`.
- Use `.claude/hooks/*` wrappers that call canonical scripts in `scripts/hooks/*`.
- Do not duplicate policy text here unless the behavior is Claude-specific.

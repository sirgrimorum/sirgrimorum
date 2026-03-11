---
name: agent-governance
description: Bootstrap or evolve AI assistant governance using the self-contained template and references in this skill. Use when a user asks to initialize governance files in a repo, adapt an existing repo to the governance model, upgrade governance patterns with project-aware edits, or run a final low-token governance pass before PR/commit after agent-assisted changes.
---

# Agent Governance

Use this skill as the governance operator.

## Self-Contained Assets

- Template root: `assets/project-bootstrap-template/`
- References:
  - `references/workflow.md`
  - `references/compliance-map.md`
  - `references/agents-management-patterns.md`
  - `references/ai-development-guide.md` (generic baseline to adapt per project)

## Modes

### 1) Bootstrap (deterministic)

Use script copy for missing-file initialization only.

```bash
bash skills/agent-governance/scripts/agent-governance-sync.sh bootstrap
```

### 2) Adapt (agent-driven)

Use agent reasoning and project context.

Process:

1. Read `references/workflow.md` and `references/compliance-map.md`.
2. Read only relevant template files from `assets/project-bootstrap-template/`.
3. Inspect current repo governance files.
4. Apply minimal contextual edits (do not overwrite project-specific architecture/content).
5. Keep `AGENTS.md` as canonical and adapters minimal.
6. Update plan docs, PR-template workflow, and `docs/ai-development-guide.md` if needed.

### 3) Upgrade (agent-driven)

Use when repository already has governance structure but needs policy/model upgrades.

Process:

1. Diff current repo against `assets/project-bootstrap-template/` selectively.
2. Apply upgrades intentionally, preserving domain-specific sections.
3. Update command interfaces (`Makefile`) and docs for current expectations.
4. Add/refresh only the files required to comply with the upgraded model.

### 4) Finalize (agent-driven, low-token)

Run as final step before PR (branch workflow) or before commit on `main` if working there.

Process:

1. Detect whether the current task require updates given the governance layers changed.
2. If no, skip governance pass.
3. If yes, perform minimal pass on governance-critical files only:
   - `AGENTS.md`, adapter files, relevant docs, plan/pr templates, and make targets.
4. Keep token usage low by reading only touched/related files.

## Incremental Disclosure

1. Start with this file.
2. Open `references/workflow.md` if mode selection or execution sequence is unclear.
3. Open `references/compliance-map.md` for managed layers and scope boundaries.
4. Open copied governance references only when deeper guidance is needed.

## Guardrails

- Never do bulk destructive overwrites in adapt/upgrade/finalize.
- Preserve project-specific architecture and product constraints.
- Prefer smallest compliant diff.
- Keep `.env` usage minimized and config centralized.
- Keep feature/foundation planning and E2E outcomes explicit.

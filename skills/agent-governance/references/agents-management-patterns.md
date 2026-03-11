# Agents Management Patterns

Operational playbook for maintaining the multi-assistant guidance system (Codex, Claude, Gemini, Copilot) with consistent behavior.

## 1. Structure Pattern

Use progressive disclosure, not one giant file.

- Root context:
  - `AGENTS.md` (canonical, cross-tool source of truth)
  - `CLAUDE.md` (Claude adapter, minimal)
  - `CODEX.md` (Codex adapter, minimal)
- Tool-specific adapters:
  - `.gemini/GEMINI.md` (minimal)
  - `.github/copilot-instructions.md`
- Scoped context:
  - `apps/*/AGENTS.md`
  - `packages/*/AGENTS.md`
- Deep docs:
  - `docs/` (architecture, infrastructure, style, testing)
- Canonical automation and reusable constraints:
  - `ai/rules/*` (agent-agnostic rule source)
  - `scripts/hooks/*` (agent-agnostic hook source)
- Execution plans:
  - `plan/*.md`
- PR drafts:
  - `prs/*.md` (temporary)

## 2. Rules Pattern

Author rules in layers.

1. Global rules in root `AGENTS.md`.
2. Domain/package constraints in scoped `AGENTS.md` files.
3. Canonical rule files in `ai/rules/*`.
4. Agent adapters (e.g. `.claude/rules/*`) that reference canonical rules.
5. Documentation diagrams use Mermaid code fences (` ```mermaid `); avoid ASCII-art diagrams.

Only add a new rule when:

- the mistake is recurring,
- the rule is testable/reviewable,
- the rule maps to a real architecture boundary.

## 3. Hook Pattern

Keep hooks small and best-effort.

- Prefer non-blocking hooks for formatting/lint fixes.
- Avoid heavy commands that slow iteration.
- Use hooks to enforce hygiene, not business logic correctness.
- Keep canonical hook logic in `scripts/hooks/*`.
- Agent-specific hook files should be wrappers/delegates only.

Starter hook set:

- Post-edit lint/format hook (best effort)
- Optional pre-PR verify command via `make verify`

## 4. Ways-of-Working Pattern

Always codify these as explicit assistant rules:

1. Trunk-based branching with short-lived branches.
2. Worktrees in sibling directory, not inside repo.
3. Remove worktree and local branch after merge.
4. Plan-first execution and plan updates during delivery.
5. Plans are feature-based (user capability) or foundation-based (platform capability).
6. Target E2E functional outcomes early in each track.
7. PR description prepared from `prs/*.md` draft.
8. Assistants do not commit unless explicitly requested.

## 5. IaC Governance Pattern

Keep ownership split stable:

- Terraform for foundation (network, DNS/certs, IAM baseline, observability skeleton).
- CDK for app-layer resources (compute, APIs, data stores, event pipelines).
- Manual steps only for account bootstrap and third-party dashboards.

Document this split in `docs/service-setup.md` and reference it from root guides.

## 6. Makefile Pattern (Use-Case First)

Use `Makefile` as the single command interface.

- Targets represent user/developer intent (`make dev`, `make verify`, `make deploy`), not low-level tooling details.
- Keep command surface stable even if underlying tools change.
- Include `help` target with clear descriptions.
- Include CI-oriented targets (e.g. `make ci`) and test commands by default unless explicitly exempted.

## 7. How To Recreate This System In a New Repo

1. Copy `templates/project-bootstrap/` into the new repo root.
2. Rename placeholders and adapt package/app paths.
3. Install/copy the `agent-governance` skill and validate `make agents-*` commands.
4. Configure real `make` targets and verification stack.
5. Add scoped `AGENTS.md` files for each major app/package.
6. Keep canonical rules in `ai/rules/` and canonical hooks in `scripts/hooks/`.
7. Add/adjust agent adapters (e.g. `.claude/rules/`, `.claude/hooks/`) to reference canonical sources.
8. Add initial plans in `plan/` and enforce plan updates in PR flow.
9. Use `prs/pr-description.template.md` for all PRs.
10. Keep the no-auto-commit rule in root assistant docs.

## 8. Maintenance Cadence

- On every architecture change: update root + scoped guides in same PR.
- Weekly or sprint-end: prune stale rules/hooks.
- When incidents occur: add rule/hook only if it would have prevented recurrence.

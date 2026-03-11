# Workflow (Incremental Disclosure)

## Quick Selector

- New repo or missing governance files -> `bootstrap`
- Existing repo needs compliance adjustments with project context -> `adapt`
- Existing repo needs governance model refresh -> `upgrade`
- Last step before PR/commit after agent-assisted work -> `finalize`

## Adapt Workflow (Agent-Driven)

1. Load canonical context:
   - `references/compliance-map.md`
   - `references/agents-management-patterns.md`
2. Inspect current repo governance surface.
3. Compare only relevant template files from `assets/project-bootstrap-template/`.
4. Apply smallest set of contextual edits needed to comply.
5. Keep AGENTS canonical and adapter files concise.

## Upgrade Workflow (Agent-Driven)

1. Identify which governance layers changed in template model.
2. Review corresponding files in current repo.
3. Apply targeted upgrades while preserving project-specific constraints.
4. Re-run formatting/checks for touched files.

## Finalize Workflow (Agent-Driven, Low-Token)

1. Determine if current branch require updates given the governance layers changed.
2. If no, skip to avoid unnecessary token use.
3. If yes, minimally sync governance-critical files only.
4. Ensure plan and PR-draft expectations are satisfied.

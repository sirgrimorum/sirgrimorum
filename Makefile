# <Project Name> — use-case command interface

.DEFAULT_GOAL := help

.PHONY: help install dev test test-e2e typecheck lint format build verify ci plan-check pr-draft \
        agents-bootstrap agents-adapt agents-upgrade agents-finalize agents-hooks-install clean

help: ## Show available developer use-case commands
	@echo "Developer commands"
	@echo "  make install      Install dependencies"
	@echo "  make dev          Start local development stack"
	@echo "  make test         Run core test suite"
	@echo "  make test-e2e     Run end-to-end tests"
	@echo "  make typecheck    Run type checks"
	@echo "  make lint         Lint code"
	@echo "  make format       Format files"
	@echo "  make build        Build artifacts"
	@echo "  make verify       Run local pre-PR checks"
	@echo "  make ci           Run CI-equivalent checks"
	@echo "  make plan-check   Verify plan docs are updated"
	@echo "  make pr-draft     Show PR draft location pattern"
	@echo "  make agents-bootstrap  Deterministic bootstrap (missing governance files)"
	@echo "  make agents-adapt      Guidance: run skill-driven adapt workflow"
	@echo "  make agents-upgrade    Guidance: run skill-driven upgrade workflow"
	@echo "  make agents-finalize   Guidance: run skill-driven finalize workflow"
	@echo "  make agents-hooks-install Disabled in agent-driven model"

install: ## Install dependencies
	@echo "replace with package-manager install"

dev: ## Start local dev workflow
	@echo "replace with project dev command"

test: ## Run core tests
	@echo "replace with project test command"

test-e2e: ## Run E2E tests
	@echo "replace with project E2E command"

typecheck: ## Run typecheck
	@echo "replace with project typecheck command"

lint: ## Run lint checks
	@echo "replace with project lint command"

format: ## Format codebase
	@echo "replace with project format command"

build: ## Build all deliverables
	@echo "replace with project build command"

verify: ## Standard local PR verification bundle
	$(MAKE) test
	$(MAKE) typecheck
	$(MAKE) lint

ci: ## CI-equivalent command bundle
	$(MAKE) verify
	$(MAKE) test-e2e

plan-check: ## Ensure plan docs were touched in this branch
	@git diff --name-only origin/main...HEAD | grep '^plan/' >/dev/null || \
	( echo "No plan updates detected. Update plan files before PR." && exit 1 )

pr-draft: ## Reminder for PR draft markdown location
	@echo "Create/update: prs/<scope>.md before opening PR"

AGENT_SYNC_SCRIPT := skills/agent-governance/scripts/agent-governance-sync.sh
AGENT_SYNC_ARGS ?=

agents-bootstrap: ## Deterministic bootstrap (missing governance files only)
	@test -f "$(AGENT_SYNC_SCRIPT)" || (echo "Missing $(AGENT_SYNC_SCRIPT). Add/install agent-governance skill first." && exit 1)
	bash "$(AGENT_SYNC_SCRIPT)" bootstrap --target $(CURDIR) $(AGENT_SYNC_ARGS)

agents-adapt: ## Guidance target: run skill-driven adapt workflow
	@echo ""
	@echo "=== Agent Governance: adapt ==="
	@echo ""
	@echo "This is an agent-driven workflow. Follow these steps:"
	@echo ""
	@echo "  1. Read skills/agent-governance/SKILL.md § Adapt"
	@echo "  2. Read skills/agent-governance/references/workflow.md § Adapt Workflow"
	@echo "  3. Read skills/agent-governance/references/compliance-map.md"
	@echo "  4. Inspect current repo governance files"
	@echo "  5. Compare with skills/agent-governance/assets/project-bootstrap-template/"
	@echo "  6. Apply minimal contextual edits"
	@echo ""
	@echo "Quick start per agent:"
	@echo "  Claude Code:  /agent-governance  → select 'adapt'"
	@echo "  Codex/Gemini: read skills/agent-governance/SKILL.md and follow § adapt"
	@echo ""

agents-upgrade: ## Guidance target: run skill-driven upgrade workflow
	@echo ""
	@echo "=== Agent Governance: upgrade ==="
	@echo ""
	@echo "This is an agent-driven workflow. Follow these steps:"
	@echo ""
	@echo "  1. Read skills/agent-governance/SKILL.md § Upgrade"
	@echo "  2. Read skills/agent-governance/references/workflow.md § Upgrade Workflow"
	@echo "  3. Read skills/agent-governance/references/compliance-map.md"
	@echo "  4. Diff repo against skills/agent-governance/assets/project-bootstrap-template/"
	@echo "  5. Apply upgrades preserving domain-specific sections"
	@echo ""
	@echo "Quick start per agent:"
	@echo "  Claude Code:  /agent-governance  → select 'upgrade'"
	@echo "  Codex/Gemini: read skills/agent-governance/SKILL.md and follow § upgrade"
	@echo ""

agents-finalize: ## Guidance target: run skill-driven finalize workflow
	@echo ""
	@echo "=== Agent Governance: finalize ==="
	@echo ""
	@echo "This is an agent-driven workflow. Follow these steps:"
	@echo ""
	@echo "  1. Read skills/agent-governance/SKILL.md § Finalize"
	@echo "  2. Check if current branch touched governance-related files"
	@echo "  3. If no governance changes needed, skip (save tokens)"
	@echo "  4. If yes, minimal pass on: AGENTS.md, adapters, docs, plan/pr templates"
	@echo ""
	@echo "Quick start per agent:"
	@echo "  Claude Code:  /agent-governance  → select 'finalize'"
	@echo "  Codex/Gemini: read skills/agent-governance/SKILL.md and follow § finalize"
	@echo ""

agents-hooks-install: ## Disabled: finalize is agent-driven
	@echo "Disabled: adapt/upgrade/finalize are intentionally agent-driven workflows."
	@echo "Do not install deterministic hooks for finalize in this model."
	@exit 1

clean: ## Remove local build artifacts
	@echo "replace with clean commands"

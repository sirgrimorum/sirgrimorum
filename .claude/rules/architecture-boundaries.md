---
globs:
  - 'apps/**/*.ts'
  - 'packages/**/*.ts'
---

# Claude Adapter Rule — Architecture Boundaries

Canonical source: `ai/rules/engineering-principles.md`

1. Keep domain logic out of UI layers.
2. Keep transport/adapters separate from business rules.
3. Keep shared contracts centralized.
4. Avoid cross-layer imports that bypass intended boundaries.

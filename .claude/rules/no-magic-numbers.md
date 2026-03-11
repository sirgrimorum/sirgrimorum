---
globs:
  - '**/*.ts'
  - '**/*.js'
---

# Claude Adapter Rule — No Magic Numbers

Canonical source: `ai/rules/engineering-principles.md`

1. Replace unexplained literals with named constants.
2. Group tunable values in config files.
3. Document constraints and ranges close to constants.

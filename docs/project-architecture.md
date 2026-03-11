# Project Architecture

## Delivery Targets

- Each track should achieve functional E2E behavior early.
- Plans should be split into:
  - feature increments (new user ability)
  - foundation increments (new platform capability)

## Layering Principles

- Contract-first interfaces between layers.
- Keep business/methodology rules in domain/application layers, not UI widgets.
- Use BFF/backend-in-frontend (or SSR server layer) when it improves separation and simplicity.
- Keep UI layer focused on rendering and interaction.

## Simplicity and Performance

- Prefer straightforward designs over deep indirection.
- Reuse shared modules and tested patterns.
- Minimize conceptual loops and cyclic dependencies.
- Introduce dependencies only when proven useful and approved, but don't try to reinvent the wheel.

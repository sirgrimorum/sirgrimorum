# Contract-First Development

## Principle

Define interfaces and contracts before implementing adapters and UI.

## Workflow

1. Define domain and API contracts.
2. Implement business logic against contracts.
3. Implement transport/adapters.
4. Connect UI last, consuming stable contracts.

## Benefits

- Clear boundaries
- Better testability
- Easier parallel work across backend/frontend tracks

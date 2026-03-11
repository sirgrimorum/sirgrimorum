# Branching Strategy

## Model

- Trunk-based development.
- `main` always deployable.
- Production via tags.
- Feature and foundation work are both short-lived and merged continuously.

## Branch Names

- `feat/<scope>`
- `fix/<scope>`
- `chore/<scope>`
- `hotfix/<scope>`

## Worktrees

- Create worktrees in a sibling directory.
- Give worktree branches names based on their branch names (without the prefix).
- Keep branch lifetime short (1-3 days).
- Remove worktree and branch after merge.

```bash
mkdir -p ../project-wt
git worktree add ../project-wt/feat-scope -b feat/scope
# after merge
git worktree remove ../project-wt/feat-scope
git branch -d feat/scope
```

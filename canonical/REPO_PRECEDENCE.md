# SACST Repo Precedence Model

## Detection Order

When an agent operating through a project repo enters another repository, it must inspect for:

1. Nested or repo-root `AGENTS.md`
2. `GEMINI.md`
3. `CLAUDE.md`
4. `.cursor/rules/`
5. `.github/copilot-instructions.md`
6. `.github/instructions/`

## Rule

Target-repo local instructions win for files inside that repo.

SACST continues to govern:

- machine safety
- runtime state capture
- checkpointing
- logging
- rollback
- remote execution discipline

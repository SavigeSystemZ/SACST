# Gemini Operating Context — SACST

You are working on SACST itself, not on a live machine instance.

## Load First

1. `AGENTS.md`
2. `TEMPLATE_CONTEXT.md`
3. `canonical/ARCHITECTURE.md`
4. `canonical/RUNTIME_BOUNDARY.md`
5. `canonical/TEMPLATE_MUTATION_POLICY.md`
6. `canonical/REPO_PRECEDENCE.md`

## Operating Rules

- SACST is a reusable template and meta-system for sysadmin and network-admin workflows.
- Do not create or keep live project runtime data inside this repo.
- Keep repo-root policy, schemas, templates, adapter generation, and tests aligned.
- When designing project behavior, generate self-contained project repos outside SACST.
- If a task later enters another repository, that repository's local instructions outrank SACST guidance for file edits there.

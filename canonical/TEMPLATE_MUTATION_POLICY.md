# SACST Template Mutation Policy

SACST changes are meta-system changes.

## Rules

- Update canonical docs before or together with command behavior.
- Never accept live project runtime into SACST.
- Treat hierarchy, runtime-boundary, and precedence changes as high-risk template changes.
- Keep migration notes whenever a project sync may be affected.

## Required Checks

- Template validation
- Meta-system validation with `bin/sys-meta-check`
- Relevant integration tests
- Adapter surface review
- Schema impact review
- Migration and adoption impact review when project-managed files change

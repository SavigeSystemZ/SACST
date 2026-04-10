# SACST Non-Functional Requirements

## Security

- SACST must never persist secrets in canonical template artifacts.
- SACST must never persist project-specific target findings, exploit evidence, private configs, or raw credential material.
- Critical actions must require logging, checkpointing, and validation.
- Repo-precedence detection must protect target repos from host-side override.
- Security assessment actions must be default-deny unless a project-local scope file allows the activity.

## Reliability

- Project repos must remain usable without runtime path dependencies back to SACST.
- Generated files must include provenance and schema/version metadata.
- Validation commands must distinguish template validation from project validation.

## Auditability

- Every mutation and every critical read must be attributable to a session, actor, mode, and target.
- Rollback information must exist for all critical actions.

## Portability

- SACST must not hardcode any specific host such as GhostZ.
- Platform support must be modular and extensible.
- Vendor and command research must be source-cited, project-local, and replaceable as vendor behavior changes.

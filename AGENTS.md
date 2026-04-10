# SACST Operating Contract

SACST is a template and meta-system for sysadmin and network-admin work. It is not an application repo and it is not a live machine instance.

## Read Order

1. `TEMPLATE_CONTEXT.md`
2. `canonical/ARCHITECTURE.md`
3. `canonical/RUNTIME_BOUNDARY.md`
4. `canonical/TEMPLATE_MUTATION_POLICY.md`
5. `canonical/REPO_PRECEDENCE.md`
6. `canonical/SECURITY_BASELINE.md`
7. `canonical/VENDOR_RESEARCH_PROTOCOL.md`
8. `canonical/CREDENTIAL_BOUNDARY.md`
9. `canonical/AUTHORIZED_SECURITY_TESTING.md`
10. `canonical/VALIDATION_MATRIX.md`

## Rules

- Preserve template/runtime separation. Never store live instance state in SACST.
- Treat repo root as the single canonical framework location.
- Prefer surgical edits over broad rewrites, but remove broken hierarchy assumptions rather than preserving them.
- When changing canonical policy, update adapters, schemas, templates, and validation surfaces in the same change.
- Keep the system explicitly optimized for system administration, network administration, and infrastructure operations.
- Keep live command research as a project-local, source-cited workflow; do not bake transient vendor findings into the template.
- Never add raw credentials, private keys, tokens, certificates, private configs, or project-specific findings to SACST.
- Treat security testing as defensive-only unless a project repo explicitly authorizes more through `control/SECURITY_SCOPE.yaml` and rules of engagement.
- When a future task pivots into another repository, target-repo local instructions take precedence.

## Required Follow-Through

- Update any affected canonical docs and schemas together.
- Keep template files and project-generated files clearly separated.
- Validate template behavior with `bin/sys-validate --template`.
- Validate project scaffolding and normalization with the integration tests before calling the change done.
- Preserve project-specific data during project adoption and template sync.

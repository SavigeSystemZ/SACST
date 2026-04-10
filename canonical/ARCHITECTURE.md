# SACST Architecture

## Canonical Layout

- Repo root is the only canonical framework location.
- `canonical/` contains durable policy and architecture.
- `schemas/` contains machine-readable contracts.
- `templates/instance/` contains the tracked scaffold for project repos.
- `adapters/` contains shared adapter inputs and generation surfaces.
- `platforms/` contains platform-specific collection, normalization, validation, backup, and risk guidance for Linux, Windows, OPNsense, switches, and future vendor modules.
- `meta/` contains template governance and compatibility state.
- `tests/` and `examples/` contain synthetic fixtures and golden outputs.

## Runtime Split

- SACST stores template artifacts only.
- Project repos live outside SACST and are self-contained.
- Project repos track curated truth but not volatile runtime, raw audit, logs, or checkpoints.
- Project repos own credential references, security-testing scope, and vendor research notes; SACST owns only the reusable policies, templates, schemas, and helpers for those surfaces.
- Unknown vendors and device classes use the `generic-vendor` fallback until a sanitized platform module is promoted.

## Control-Plane Lifecycle

1. Scaffold a project repo from the template.
2. Collect raw audit data into the project repo.
3. Normalize raw data into stable context.
4. Generate tool-specific adapters from canonical truth.
5. Research unfamiliar vendor or OS command syntax when policy requires it.
6. Create a platform plan for unmodeled vendors before mutation.
7. Run operations through plan, preflight, apply, validate, and rollback-ready workflows.
8. Promote reusable improvements back into SACST only through the meta-system.

## Precedence

1. Target repo local instructions
2. Project repo local instructions
3. SACST-generated adapters
4. SACST canonical policy
5. Project normalized truth
6. Runtime state

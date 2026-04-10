# SACST Self-Healing Model

SACST self-healing is conservative repair of known-safe mechanical drift. It is not permission to hide failures, rewrite project-specific data, or bypass human approval for critical operations.

## Safe Automatic Repairs

- Recreate required runtime directories.
- Regenerate adapter surfaces from canonical truth.
- Reconcile missing normalization manifests from existing normalized context.
- Upgrade runtime state files to the current schema when source values are present.
- Restore executable bits on SACST command and integration-test scripts.
- Archive invalid legacy logs during adoption and start fresh managed logs.

## Unsafe Repairs

- Replacing project-specific context without an adoption or sync report.
- Deleting unknown files.
- Refreshing a live project when the user has not approved overwriting normalized context.
- Applying network, firewall, boot, storage, crypto, SSH, PAM, or switch changes without preflight and rollback planning.

## Standard Repair Order

1. Run `bin/sys-meta-check` for SACST template work.
2. Run `bin/sys-validate --template` or `bin/sys-validate --project <project>`.
3. Run `bin/sys-fix --template` for template mechanical drift, or `bin/sys-fix <project>` for project drift.
4. Run the relevant validation again.
5. Use `bin/sys-release --dry-run` before treating SACST template work as complete.

## Agent Rule

Agents should prefer `sys-fix` only after reading the relevant project or template contract. Self-healing may make mechanical repairs, but it must never erase uncertainty about operational intent.

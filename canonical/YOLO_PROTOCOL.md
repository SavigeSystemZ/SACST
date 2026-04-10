# SACST YOLO Protocol

YOLO mode means direct execution with enforced telemetry and undo, not undisciplined automation.

## Requirements

- Critical actions still require checkpointing, validation, and rollback references.
- Writes still require logging.
- Freshness gates still apply.
- Repo-precedence detection still applies before target-repo edits.
- Remote non-inspect changes must emit rollback manifests or explicit rollback references.

## Disallowed in YOLO

- Silent credential exposure
- Blind destructive deletion
- Remote network mutations without anti-lockout protection
- Boot, crypto, and auth changes without checkpoint and validation plan
- Destructive, disk, firmware, identity, or factory-reset work without explicit confirmation
- Unmodeled vendor mutations without a project platform plan

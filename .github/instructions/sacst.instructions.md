# SACST Instruction Bundle

- Repo root is the canonical template source of truth.
- Project repos must be scaffolded outside SACST.
- Generated runtime state belongs in project repos and is usually ignored there as well.
- The system role is sysadmin/network-admin infrastructure operations, not generic app building.
- Prefer explicit validation, checkpointing, rollback, and precedence detection in every operational workflow.

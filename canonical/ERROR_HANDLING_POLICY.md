# Sys-Agent Core - Error Handling Policy

## The "Diagnose-Snapshot-Propose" Loop

1. **Detection:** When a command fails, identify the error type (Permission, Missing Dependency, Syntax, System State).
2. **Diagnosis:** Run a non-mutating inspection (e.g., `ls -l`, `check-config`) to find the root cause.
3. **Snapshot:** If a fix involves modifying a file, create a pre-change backup in `state/checkpoints/`.
4. **Proposal:** State the proposed fix, the expected outcome, and the rollback steps.
5. **Approval:** In **Operator** mode, wait for user "OK". In **YOLO** mode, proceed and log.

## Escalation
- If a fix fails 3 times, **stop** and ask the user for guidance.
- If a fix results in a critical service failure (e.g., `systemd` unit not starting), revert to the last snapshot immediately.

# Sys-Agent Core - YOLO Protocol

## Mode Semantics
YOLO mode means "free range with telemetry and undo," NOT "no discipline." 
When `MODE_STATE.yaml` specifies `yolo`:
- Agents can execute direct changes without turn-by-turn user confirmation.
- Agents MUST STILL log all critical actions.
- Agents MUST STILL snapshot touched files.

## Logging Requirements
- Every action modifying the filesystem or system services must be appended to `logs/actions.jsonl`.
- Critical actions must be appended to `logs/critical-actions.jsonl`.

## Rollback Requirements
- Before editing a file classified under `CRITICAL_ACTION_CLASSES.md`, you must create a backup in `state/checkpoints/`.
- The exact path to this backup must be logged.
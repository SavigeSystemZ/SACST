# Sys-Agent Core - Non-Functional Requirements

## Security
- Credentials and sensitive tokens must never be logged or stored in instance state.
- YOLO mode must still enforce logging and checkpointing for critical action classes.

## Reliability
- The system must function entirely locally, independent of cloud services (excluding the LLMs themselves).
- State files must be parseable YAML/JSONL.

## Auditability
- Every action performed in Operator or YOLO mode must generate a discrete entry in the action logs.
- Source references and timestamps must be present in all normalized context files.

## Portability
- The `framework/` directory must contain zero hardcoded references to the initial `GhostZ` instance.
- A new instance on a different OS must be bootable simply by running `sys-init <InstanceName>`.
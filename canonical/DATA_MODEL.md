# Sys-Agent Core - Data Model

## Core Entities

### HostInstance
- `instance_id`: Unique identifier (e.g., GhostZ)
- `host_name`: System hostname
- `platform_class`: OS classification (e.g., linux-desktop)
- `os_name`, `os_version`, `kernel`, `architecture`
- `created_at`, `last_refresh_at`, `freshness_ttl_hours`

### ModeState
- `mode`: `advisor` | `operator` | `yolo`
- `requires_confirmation_for_critical`: boolean
- `auto_log_actions`: boolean
- `auto_snapshot_touched_files`: boolean
- *Action Allowances:* `allow_package_changes`, `allow_service_changes`, etc.

### SessionLog
- `session_id`, `started_at`, `ended_at`
- `tool_name`, `operator_mode`, `task_summary`, `outcome`

### ActionLog
- `ts`, `session_id`, `actor`, `mode`, `action_class`
- `command`, `target_paths`, `before_refs`, `after_refs`, `rollback_refs`

### EffectivePermissions
- `read_scope`, `write_scope`, `command_scope`
- `prohibited_actions`, `critical_action_classes`, `repo_precedence_required`

### FeedbackEvent & LearningCandidate
Used for the self-improvement loop, tracking user signals and proposed template changes.
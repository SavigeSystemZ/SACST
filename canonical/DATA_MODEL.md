# SACST Data Model

## Template-Side Entities

### TemplateVersion
- `template_id`
- `template_version`
- `compatibility_channel`
- `updated_at_utc`

### PrecedenceManifest
- `layers[]`
- `generator`
- `generated_at_utc`

### LearningCandidate
- `candidate_id`
- `source_project`
- `surface_area[]`
- `summary`
- `sanitized`
- `validation_refs[]`

## Project-Side Tracked Entities

### ProjectProfile
- `instance_id`
- `project_root`
- `primary_platform`
- `template_version`
- `created_at_utc`

### ModePolicy
- `default_mode`
- `allowed_modes[]`
- `requires_confirmation_for_critical`
- `allow_package_changes`
- `allow_service_changes`
- `allow_network_changes`
- `allow_boot_changes`

### PermissionsPolicy
- `read_scope[]`
- `write_scope[]`
- `command_scope[]`
- `prohibited_actions[]`
- `critical_action_classes[]`
- `repo_precedence_required`

### FreshnessPolicy
- `normalized_context_ttl_hours`
- `security_context_ttl_hours`
- `require_refresh_for_critical_when_stale`

### ResearchPolicy
- `live_research_allowed`
- `prefer_primary_sources`
- `require_research_when[]`
- `prohibited_query_content[]`
- `notes_dir`

### CredentialReferences
- `secret_storage_policy`
- `references[]`

### SecurityScope
- `authorized_security_testing`
- `default_posture`
- `allowed_activities[]`
- `prohibited_activities[]`
- `rules_of_engagement_ref`
- `approval_ref`
- `evidence_handling`

### Inventory
- `devices[]`
- `network_zones[]`
- `maintenance_windows[]`

## Project-Side Generated Entities

### RuntimeState
- `instance_id`
- `project_root`
- `template_version`
- `mode`
- `latest_raw_audit_dir`
- `last_refresh_utc`
- `freshness_status`
- `normalization_manifest`

### DeviceState
- `device_name`
- `platform_family`
- `collection_scope`
- `last_collected_at_utc`
- `last_validated_at_utc`

### DeviceNormalizedBundle
- `device_name`
- `platform_family`
- `output_dir`
- `freshness_state`
- `normalization_manifest`

### ActionLog
- `ts`
- `session_id`
- `actor`
- `mode`
- `action_class`
- `targets[]`
- `command_summary`
- `before_refs[]`
- `after_refs[]`
- `rollback_refs[]`
- `status`

### SessionLog
- `session_id`
- `tool_name`
- `started_at`
- `ended_at`
- `task_summary`
- `outcome`

# SACST Inventory Model

Inventory must support real fleet operations, not just host lists.

## Required Device Fields

- `name`
- `platform_family`
- `role`
- `host`
- `transport`
- `auth_ref`
- `validation_profile`
- `risk_class`

## Recommended Fields

- `port`
- `user`
- `bastion`
- `backup_profile`
- `collector_profile`
- `backup_command`
- `rollback_capability`
- `validate_command`
- `management_probe`
- `management_interface`
- `network_zone`
- `tags`
- `maintenance_window`
- `command_timeout_seconds`
- `recheck_count`
- `recheck_interval_seconds`

## Operational Notes

- `validation_profile`, `backup_profile`, and `collector_profile` should map to platform-specific command packs or overrides.
- Profile resolution first checks `platforms/<platform>/profiles/<profile>/` and then falls back to the platform default files.
- `recheck_count` and `recheck_interval_seconds` control delayed post-change reachability rechecks for changes that may revert or destabilize after the initial validation window.
- `command_timeout_seconds` caps a single backup, apply, validate, or management-probe invocation.

#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-remote.XXXXXX")"
PROJECT="$TMP_ROOT/RemoteNode"

"$ROOT/bin/sys-init" RemoteNode --path "$PROJECT" --no-refresh
cat > "$PROJECT/inventory/devices.yaml" <<'EOF'
schema_version: 1
devices:
  - name: localnode
    platform_family: linux-desktop
    role: primary-managed-node
    host: localhost
    transport: local
    auth_ref: local-shell
    validation_profile: linux-desktop
    backup_profile: local-files
    risk_class: managed-host
    command_timeout_seconds: 90
    recheck_count: 3
    recheck_interval_seconds: 2
    validate_command: echo validated
    management_probe: echo management-ok
EOF

sed -i 's/^mode: .*/mode: yolo/' "$PROJECT/runtime/MODE_STATE.yaml"
sed -i 's/^allow_service_changes: .*/allow_service_changes: true/' "$PROJECT/runtime/MODE_STATE.yaml"
OUTPUT="$("$ROOT/bin/sys-remote" "$PROJECT" localnode "echo hi" --action-class service --dry-run --with-validate --rollback-command "echo rollback")"
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN: transport=local'
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN VALIDATE: echo validated'
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN RECHECK: count=3 interval_seconds=2'
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN TIMEOUT: 90'
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN ROLLBACK MANIFEST:'
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN ROLLBACK COMMAND: echo rollback'

echo "test_remote_dry_run.sh: PASS"

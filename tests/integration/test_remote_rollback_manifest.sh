#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-remote-rollback.XXXXXX")"
PROJECT="$TMP_ROOT/RollbackNode"

"$ROOT/bin/sys-init" RollbackNode --path "$PROJECT" --no-refresh
cat > "$PROJECT/inventory/devices.yaml" <<'EOF'
schema_version: 1
devices:
  - name: localnode
    platform_family: linux-desktop
    role: primary-managed-node
    host: localhost
    transport: local
    auth_ref: local-shell
    validation_profile: quick
    backup_profile: local-files
    risk_class: managed-host
    backup_command: echo backup-ok
    validate_command: echo validate-ok
    management_probe: echo probe-ok
    command_timeout_seconds: 30
    recheck_count: 0
EOF

sed -i 's/^mode: .*/mode: yolo/' "$PROJECT/runtime/MODE_STATE.yaml"
sed -i 's/^allow_service_changes: .*/allow_service_changes: true/' "$PROJECT/runtime/MODE_STATE.yaml"
"$ROOT/bin/sys-refresh" "$PROJECT" --source "$ROOT/tests/fixtures/linux-desktop/minimal/raw-audit/20240101T000000Z" >/dev/null

OUTPUT="$("$ROOT/bin/sys-remote" "$PROJECT" localnode "echo apply-ok" --action-class service --with-backup --with-validate --report --rollback-command "echo rollback-ok")"
printf '%s\n' "$OUTPUT" | grep -q 'apply-ok'

ROLLBACK_MANIFEST="$(find "$PROJECT/state/rollback" -name 'remote-localnode-*.yaml' -type f | head -n 1)"
test -n "$ROLLBACK_MANIFEST"
grep -q 'rollback-ok' "$ROLLBACK_MANIFEST"
grep -q 'rollback_refs' "$PROJECT/logs/actions.jsonl"
"$ROOT/bin/sys-validate" --project "$PROJECT" --strict >/dev/null

echo "test_remote_rollback_manifest.sh: PASS"

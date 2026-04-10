#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-device-opnsense.XXXXXX")"
PROJECT="$TMP_ROOT/MultiNode"
FIXTURE="$ROOT/tests/fixtures/opnsense/minimal/raw-audit/20240102T000000Z"

"$ROOT/bin/sys-init" MultiNode --path "$PROJECT" --no-refresh
cat > "$PROJECT/inventory/devices.yaml" <<'EOF'
schema_version: 1
devices:
  - name: MultiNode-primary
    platform_family: linux-desktop
    role: primary-managed-node
    host: localhost
    transport: local
    auth_ref: local-shell
    validation_profile: linux-desktop
    backup_profile: local-files
    risk_class: managed-host
  - name: edge-fw
    platform_family: opnsense
    role: firewall
    host: fw.example
    transport: ssh
    auth_ref: ssh-key
    validation_profile: opnsense
    backup_profile: opnsense-config
    risk_class: network-critical
    command_timeout_seconds: 60
    recheck_count: 2
    recheck_interval_seconds: 1
EOF

"$ROOT/bin/sys-refresh" "$PROJECT" --device edge-fw --source "$FIXTURE" --report
"$ROOT/bin/sys-validate" --project "$PROJECT"

test -f "$PROJECT/context/normalized/devices/edge-fw/HOST_PROFILE.md"
test -f "$PROJECT/runtime/devices/edge-fw/DEVICE_STATE.yaml"
grep -q "device_name: edge-fw" "$PROJECT/context/normalized/devices/edge-fw/HOST_PROFILE.md"
grep -q "platform_family: opnsense" "$PROJECT/runtime/devices/edge-fw/DEVICE_STATE.yaml"
ls "$PROJECT/reports/latest"/REFRESH_REPORT_*.md >/dev/null

echo "test_refresh_device_opnsense.sh: PASS"

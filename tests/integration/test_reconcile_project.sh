#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-reconcile.XXXXXX")"
PROJECT="$TMP_ROOT/ReconcileNode"

"$ROOT/bin/sys-init" ReconcileNode --path "$PROJECT" --no-refresh
mkdir -p "$PROJECT/context/normalized" "$PROJECT/context/normalized/devices/fw-a"
cat > "$PROJECT/context/normalized/HOST_PROFILE.md" <<'EOF'
# Host Profile

- generated_at_utc: legacy
EOF
cat > "$PROJECT/context/normalized/SERVICES.md" <<'EOF'
# Services

legacy service list
EOF
cat > "$PROJECT/context/normalized/devices/fw-a/HOST_PROFILE.md" <<'EOF'
# Host Profile

- generated_at_utc: legacy
- device_name: fw-a
EOF
cat > "$PROJECT/inventory/devices.yaml" <<'EOF'
schema_version: 1
devices:
  - name: ReconcileNode-primary
    platform_family: linux-desktop
    role: primary-managed-node
    host: localhost
    transport: local
    auth_ref: local-shell
    validation_profile: linux-desktop
    backup_profile: local-files
    risk_class: managed-host
  - name: fw-a
    platform_family: opnsense
    role: firewall
    host: fw.example
    transport: ssh
    auth_ref: ssh-key
    validation_profile: opnsense
    backup_profile: opnsense-config
    risk_class: network-critical
EOF

"$ROOT/bin/sys-reconcile-project" "$PROJECT" --report
"$ROOT/bin/sys-validate" --project "$PROJECT"

test -f "$PROJECT/context/normalized/NORMALIZATION_MANIFEST.yaml"
test -f "$PROJECT/context/normalized/FRESHNESS_STATE.yaml"
test -f "$PROJECT/context/normalized/devices/fw-a/NORMALIZATION_MANIFEST.yaml"
test -f "$PROJECT/runtime/devices/fw-a/DEVICE_STATE.yaml"
ls "$PROJECT/reports/latest"/RECONCILE_REPORT_*.md >/dev/null

echo "test_reconcile_project.sh: PASS"

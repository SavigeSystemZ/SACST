#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-remote-profile.XXXXXX")"
PROJECT="$TMP_ROOT/RemoteProfileNode"

"$ROOT/bin/sys-init" RemoteProfileNode --path "$PROJECT" --no-refresh
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
EOF

OUTPUT="$("$ROOT/bin/sys-remote" "$PROJECT" localnode "echo hi" --action-class inspect --dry-run --with-validate)"
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN VALIDATE: echo profile-validate-ok'
printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN PROBE: echo profile-probe-ok'

echo "test_remote_profile_dry_run.sh: PASS"

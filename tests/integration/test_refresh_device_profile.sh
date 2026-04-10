#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-device-profile.XXXXXX")"
PROJECT="$TMP_ROOT/ProfileNode"

"$ROOT/bin/sys-init" ProfileNode --path "$PROJECT" --no-refresh
cat > "$PROJECT/inventory/devices.yaml" <<'EOF'
schema_version: 1
devices:
  - name: ProfileNode-primary
    platform_family: linux-desktop
    role: primary-managed-node
    host: localhost
    transport: local
    auth_ref: local-shell
    validation_profile: quick
    backup_profile: local-files
    collector_profile: quick
    risk_class: managed-host
EOF

"$ROOT/bin/sys-refresh" "$PROJECT" --device ProfileNode-primary --output-scope both
"$ROOT/bin/sys-validate" --project "$PROJECT" --strict

grep -q 'ProfileOS' "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q 'profile-service.service' "$PROJECT/context/normalized/SERVICES.md"
grep -q 'Profile CPU' "$PROJECT/context/normalized/devices/ProfileNode-primary/HARDWARE.md"

echo "test_refresh_device_profile.sh: PASS"

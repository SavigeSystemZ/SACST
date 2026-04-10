#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-vendor-profile.XXXXXX")"
PROJECT="$TMP_ROOT/VendorNode"

"$ROOT/bin/sys-schema-validate" vendor-profile-catalog.schema.yaml "$ROOT/platforms/vendor-profiles/profiles.yaml" >/dev/null
"$ROOT/bin/sys-vendor-profile" --list | grep -q 'cisco-ios'
"$ROOT/bin/sys-vendor-profile" --vendor mikrotik-routeros | grep -q 'safe-mode'

"$ROOT/bin/sys-init" VendorNode --path "$PROJECT" --no-refresh
PLAN_PATH="$("$ROOT/bin/sys-vendor-profile" --vendor cisco-ios --project "$PROJECT" --emit-plan)"
test -f "$PLAN_PATH"
grep -q 'Cisco' "$PLAN_PATH"
grep -q 'Validation and Rollback Gate' "$PLAN_PATH"

echo "test_vendor_profile.sh: PASS"

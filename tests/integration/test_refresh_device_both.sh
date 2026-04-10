#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-device-both.XXXXXX")"
PROJECT="$TMP_ROOT/PrimaryNode"
FIXTURE="$ROOT/tests/fixtures/linux-desktop/minimal/raw-audit/20240101T000000Z"

"$ROOT/bin/sys-init" PrimaryNode --path "$PROJECT" --no-refresh
"$ROOT/bin/sys-refresh" "$PROJECT" --device PrimaryNode-primary --source "$FIXTURE" --output-scope both
"$ROOT/bin/sys-validate" --project "$PROJECT" --strict

test -f "$PROJECT/context/normalized/devices/PrimaryNode-primary/HOST_PROFILE.md"
test -f "$PROJECT/runtime/devices/PrimaryNode-primary/DEVICE_STATE.yaml"
grep -q "device_name: PrimaryNode-primary" "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q '^freshness_status: "fresh"$\|^freshness_status: fresh$' "$PROJECT/runtime/RUNTIME_STATE.yaml"

echo "test_refresh_device_both.sh: PASS"

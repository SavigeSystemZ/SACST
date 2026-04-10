#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-switch.XXXXXX")"
PROJECT="$TMP_ROOT/CoreSwitch"
FIXTURE="$ROOT/tests/fixtures/switch/minimal/raw-audit/20240103T000000Z"

"$ROOT/bin/sys-init" CoreSwitch --path "$PROJECT" --platform switch --no-refresh
"$ROOT/bin/sys-refresh" "$PROJECT" --source "$FIXTURE"
"$ROOT/bin/sys-validate" --project "$PROJECT" --strict

grep -q "Managed Switch" "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q "CBS350-24T-4G" "$PROJECT/context/normalized/HARDWARE.md"
grep -q "workstations" "$PROJECT/context/normalized/NETWORK_AND_PORTS.md"

echo "test_normalize_switch.sh: PASS"

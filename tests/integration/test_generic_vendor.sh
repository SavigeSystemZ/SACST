#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-generic.XXXXXX")"
PROJECT="$TMP_ROOT/GenericNode"
SOURCE="$ROOT/tests/fixtures/generic-vendor/minimal/raw-audit/20240105T000000Z"

"$ROOT/bin/sys-init" GenericNode --path "$PROJECT" --platform generic-vendor --no-refresh
"$ROOT/bin/sys-refresh" "$PROJECT" --source "$SOURCE"

grep -q 'platform: generic-vendor' "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q 'normalization_mode: generic-vendor' "$PROJECT/context/normalized/SECURITY_POSTURE.md"
grep -q '01_system.txt' "$PROJECT/context/normalized/NETWORK_AND_PORTS.md"
"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null

echo "test_generic_vendor.sh: PASS"

#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-opnsense.XXXXXX")"
PROJECT="$TMP_ROOT/EdgeFW"
FIXTURE="$ROOT/tests/fixtures/opnsense/minimal/raw-audit/20240102T000000Z"

"$ROOT/bin/sys-init" EdgeFW --path "$PROJECT" --platform opnsense --no-refresh
"$ROOT/bin/sys-refresh" "$PROJECT" --source "$FIXTURE"
"$ROOT/bin/sys-validate" --project "$PROJECT" --strict

grep -q "OPNsense" "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q "DEC740" "$PROJECT/context/normalized/HARDWARE.md"
grep -q "MgmtHosts" "$PROJECT/context/normalized/SECURITY_POSTURE.md"

echo "test_normalize_opnsense.sh: PASS"

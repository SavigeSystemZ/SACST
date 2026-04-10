#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-normalize.XXXXXX")"
PROJECT="$TMP_ROOT/FixtureNode"
FIXTURE="$ROOT/tests/fixtures/linux-desktop/minimal/raw-audit/20240101T000000Z"

"$ROOT/bin/sys-init" FixtureNode --path "$PROJECT" --no-refresh
"$ROOT/bin/sys-refresh" "$PROJECT" --source "$FIXTURE"
"$ROOT/bin/sys-validate" --project "$PROJECT" --strict

grep -q "Ubuntu" "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q "Example CPU" "$PROJECT/context/normalized/HARDWARE.md"
grep -q "Docker version 26.1.0" "$PROJECT/context/normalized/AI_STACK.md"

echo "test_normalize.sh: PASS"

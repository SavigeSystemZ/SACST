#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-scaffold.XXXXXX")"
PROJECT="$TMP_ROOT/TestNode"

"$ROOT/bin/sys-init" TestNode --path "$PROJECT" --no-refresh
"$ROOT/bin/sys-validate" --project "$PROJECT"

test -f "$PROJECT/AGENTS.md"
test -f "$PROJECT/control/PROJECT_PROFILE.yaml"
test -f "$PROJECT/inventory/devices.yaml"

echo "test_scaffold.sh: PASS"

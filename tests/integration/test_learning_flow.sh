#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-learning.XXXXXX")"
PROJECT="$TMP_ROOT/LearnNode"

"$ROOT/bin/sys-init" LearnNode --path "$PROJECT" --no-refresh
CANDIDATE_PATH="$("$ROOT/bin/sys-export-candidate" "$PROJECT" learn-node-1 "Candidate summary")"
IMPORTED_PATH="$("$ROOT/bin/sys-import-candidate" "$CANDIDATE_PATH")"
"$ROOT/bin/sys-promote-candidate" "$IMPORTED_PATH" accept >/dev/null

test -f "$ROOT/learning/accepted/learn-node-1.md"
rm -f "$ROOT/learning/accepted/learn-node-1.md"

echo "test_learning_flow.sh: PASS"

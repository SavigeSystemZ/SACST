#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-sync-context.XXXXXX")"
PROJECT="$TMP_ROOT/ContextNode"

"$ROOT/bin/sys-init" ContextNode --path "$PROJECT" --no-refresh
cat >> "$PROJECT/LOCAL_CONTEXT.md" <<'EOF'

## Project-Specific Context

Keep this local-only note.
EOF

"$ROOT/bin/sys-sync-template" "$PROJECT" --report >/dev/null
"$ROOT/bin/sys-sync-template" "$PROJECT" --report >/dev/null

COUNT="$(grep -c '^## Project-Specific Context$' "$PROJECT/LOCAL_CONTEXT.md")"
test "$COUNT" = "1"
grep -q 'Keep this local-only note.' "$PROJECT/LOCAL_CONTEXT.md"

echo "test_sync_preserves_context.sh: PASS"

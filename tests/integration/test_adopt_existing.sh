#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-adopt.XXXXXX")"
PROJECT="$TMP_ROOT/GhostZ"

mkdir -p "$PROJECT/control"
cat > "$PROJECT/LOCAL_CONTEXT.md" <<'EOF'
# Legacy Local Context

Legacy project-specific notes.
EOF
cat > "$PROJECT/control/AGENTS.md" <<'EOF'
# Legacy Control AGENTS
EOF
cat > "$PROJECT/control/GEMINI.md" <<'EOF'
# Legacy Control GEMINI
EOF
cat > "$PROJECT/control/SYSTEM_MAP.md" <<'EOF'
# Legacy System Map
EOF
mkdir -p "$PROJECT/logs" "$PROJECT/runtime"
printf '{"legacy":"entry"}\n' > "$PROJECT/logs/actions.jsonl"
printf '# Legacy plan\n' > "$PROJECT/runtime/CURRENT_PLAN.md"
cat > "$PROJECT/.gitignore" <<'EOF'
custom-ignore/
EOF
git -C "$PROJECT" init -b main >/dev/null 2>&1 || git -C "$PROJECT" init >/dev/null 2>&1

"$ROOT/bin/sys-init" GhostZ --path "$PROJECT" --adopt-existing --no-refresh
"$ROOT/bin/sys-validate" --project "$PROJECT"

test -f "$PROJECT/AGENTS.md"
test ! -f "$PROJECT/control/AGENTS.md"
test ! -f "$PROJECT/control/GEMINI.md"
grep -q "Project-Specific Context" "$PROJECT/LOCAL_CONTEXT.md"
grep -q "Legacy project-specific notes." "$PROJECT/LOCAL_CONTEXT.md"
grep -q "custom-ignore/" "$PROJECT/.gitignore"
test ! -s "$PROJECT/logs/actions.jsonl"
grep -q "Legacy plan" "$PROJECT/runtime/CURRENT_PLAN.md"
find "$PROJECT/state/imports" -type f | grep -q 'LOCAL_CONTEXT.md'
find "$PROJECT/state/imports" -type f | grep -q 'legacy-control/control/AGENTS.md'
find "$PROJECT/state/imports" -type f | grep -q 'legacy-logs/logs/actions.jsonl'

echo "test_adopt_existing.sh: PASS"

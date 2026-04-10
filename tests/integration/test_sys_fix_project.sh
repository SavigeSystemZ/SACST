#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-fix.XXXXXX")"
PROJECT="$TMP_ROOT/FixNode"

"$ROOT/bin/sys-init" FixNode --path "$PROJECT" --no-refresh
rm -f "$PROJECT/runtime/ADAPTER_MANIFEST.yaml"
rm -f "$PROJECT/context/normalized/NORMALIZATION_MANIFEST.yaml"
mkdir -p "$PROJECT/context/normalized"
cat > "$PROJECT/context/normalized/HOST_PROFILE.md" <<'EOF'
# Host Profile

- generated_at_utc: legacy
EOF

"$ROOT/bin/sys-fix" "$PROJECT" >/dev/null
"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null

test -f "$PROJECT/runtime/ADAPTER_MANIFEST.yaml"
test -f "$PROJECT/context/normalized/NORMALIZATION_MANIFEST.yaml"
test -f "$PROJECT/reports/latest"/RECONCILE_REPORT_*.md

echo "test_sys_fix_project.sh: PASS"

#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-stale.XXXXXX")"
PROJECT="$TMP_ROOT/StaleNode"

"$ROOT/bin/sys-init" StaleNode --path "$PROJECT" --no-refresh
cat > "$PROJECT/runtime/RUNTIME_STATE.yaml" <<'EOF'
schema_version: 1
instance_id: StaleNode
project_root: REPLACEME
template_version: 1.0.0
mode: operator
last_refresh_utc: 2000-01-01T00:00:00Z
latest_raw_audit_dir: ""
normalization_manifest: ""
freshness_status: stale
normalized_context_dir: REPLACEME/context/normalized
EOF
sed -i "s#REPLACEME#$PROJECT#g" "$PROJECT/runtime/RUNTIME_STATE.yaml"
sed -i 's/^mode: .*/mode: operator/' "$PROJECT/runtime/MODE_STATE.yaml"
sed -i 's/^allow_network_changes: .*/allow_network_changes: true/' "$PROJECT/runtime/MODE_STATE.yaml"

if "$ROOT/bin/sys-preflight" "$PROJECT" --action-class network --confirmed >/dev/null 2>&1; then
  echo "stale preflight unexpectedly passed"
  exit 1
fi

echo "test_stale_preflight.sh: PASS"

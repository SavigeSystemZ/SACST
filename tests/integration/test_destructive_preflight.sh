#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-destructive.XXXXXX")"
PROJECT="$TMP_ROOT/DestructiveNode"

"$ROOT/bin/sys-init" DestructiveNode --path "$PROJECT" --no-refresh
sed -i 's/^mode: .*/mode: yolo/' "$PROJECT/runtime/MODE_STATE.yaml"
sed -i 's/^allow_boot_changes: .*/allow_boot_changes: true/' "$PROJECT/runtime/MODE_STATE.yaml"

if "$ROOT/bin/sys-preflight" "$PROJECT" --action-class disk >/dev/null 2>&1; then
  echo "disk action unexpectedly passed without confirmation"
  exit 1
fi

"$ROOT/bin/sys-preflight" "$PROJECT" --action-class disk --confirmed >/dev/null

echo "test_destructive_preflight.sh: PASS"

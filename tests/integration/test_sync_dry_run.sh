#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-syncdry.XXXXXX")"
PROJECT="$TMP_ROOT/SyncDryNode"

"$ROOT/bin/sys-init" SyncDryNode --path "$PROJECT" --no-refresh
OUTPUT="$("$ROOT/bin/sys-sync-template" "$PROJECT" --dry-run)"

printf '%s\n' "$OUTPUT" | grep -q 'DRY RUN: sync'
printf '%s\n' "$OUTPUT" | grep -q 'control/PROJECT_PROFILE.yaml'

echo "test_sync_dry_run.sh: PASS"

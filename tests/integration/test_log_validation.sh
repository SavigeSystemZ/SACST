#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-logs.XXXXXX")"
PROJECT="$TMP_ROOT/LogNode"

"$ROOT/bin/sys-init" LogNode --path "$PROJECT" --no-refresh
"$ROOT/bin/sys-log" --project "$PROJECT" --kind action --session-id session-1 --action-class inspect --mode advisor --targets localhost --command "echo ok" --message "action message" >/dev/null
"$ROOT/bin/sys-log" --project "$PROJECT" --kind critical --session-id session-1 --action-class firewall --mode operator --targets edge-fw --command "pfctl -sr" --message "critical message" >/dev/null
"$ROOT/bin/sys-log" --project "$PROJECT" --kind feedback --session-id session-1 --status neutral --message "feedback note" >/dev/null
"$ROOT/bin/sys-log" --project "$PROJECT" --kind session --session-id session-1 --actor codex --message "session start" >/dev/null
"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null

echo "test_log_validation.sh: PASS"

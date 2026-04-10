#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-platform-plan.XXXXXX")"
PROJECT="$TMP_ROOT/PlanNode"

"$ROOT/bin/sys-init" PlanNode --path "$PROJECT" --no-refresh
PLAN_PATH="$("$ROOT/bin/sys-platform-plan" "$PROJECT" --vendor ExampleVendor --device-class router --model EdgeBox-1000 --access-method ssh --intent "evaluate routing syntax")"

test -f "$PLAN_PATH"
grep -q 'Vendor / Platform Work Plan' "$PLAN_PATH"
grep -q 'Default-Credential Boundary' "$PLAN_PATH"
grep -q 'Validation and Rollback Gate' "$PLAN_PATH"
grep -q 'Security Scope Gate' "$PLAN_PATH"

echo "test_platform_plan.sh: PASS"

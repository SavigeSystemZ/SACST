#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-research.XXXXXX")"
PROJECT="$TMP_ROOT/ResearchNode"

"$ROOT/bin/sys-init" ResearchNode --path "$PROJECT" --no-refresh

PLAN_PATH="$("$ROOT/bin/sys-research-plan" "$PROJECT" --topic "OPNsense firewall rule syntax" --vendor OPNsense --platform opnsense --intent "validate a candidate rule command")"

test -f "$PLAN_PATH"
grep -q '# Research Plan' "$PLAN_PATH"
grep -q 'prefer_primary_sources: true' "$PLAN_PATH"
grep -q 'raw_credentials' "$PLAN_PATH"
grep -q 'Source Ledger' "$PLAN_PATH"
grep -q 'Execution Gate' "$PLAN_PATH"

"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null

echo "test_research_plan.sh: PASS"

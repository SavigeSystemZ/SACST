#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-scope.XXXXXX")"
PROJECT="$TMP_ROOT/ScopeNode"

"$ROOT/bin/sys-init" ScopeNode --path "$PROJECT" --no-refresh
sed -i 's/^mode: .*/mode: yolo/' "$PROJECT/runtime/MODE_STATE.yaml"

"$ROOT/bin/sys-scope-check" "$PROJECT" --activity inventory >/dev/null
"$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity inventory >/dev/null

if "$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity exploit_validation >/dev/null 2>&1; then
  echo "exploit_validation unexpectedly passed without explicit scope"
  exit 1
fi

cat > "$PROJECT/control/SECURITY_SCOPE.yaml" <<'EOF'
schema_version: 1
authorized_security_testing: true
default_posture: authorized-pentest
allowed_activities:
  - inventory
  - exposure_review
  - configuration_review
  - patch_verification
  - hardening
  - exploit_validation
prohibited_activities:
  - denial_of_service
  - social_engineering
  - destructive_testing
rules_of_engagement_ref: docs/roe-approved.md
approval_ref: ticket/SCOPE-1
evidence_handling: redact-sensitive-data
notes: "Synthetic test scope."
EOF

"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null
"$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity exploit_validation >/dev/null

echo "test_security_scope.sh: PASS"

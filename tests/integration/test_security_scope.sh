#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-scope.XXXXXX")"
PROJECT="$TMP_ROOT/ScopeNode"

"$ROOT/bin/sys-init" ScopeNode --path "$PROJECT" --no-refresh
sed -i 's/^mode: .*/mode: yolo/' "$PROJECT/runtime/MODE_STATE.yaml"

"$ROOT/bin/sys-scope-check" "$PROJECT" --activity inventory >/dev/null
"$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity inventory >/dev/null
"$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity exploit_validation >/dev/null
"$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity credential_audit >/dev/null

if "$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity action_outside_operator_tasking >/dev/null 2>&1; then
  echo "out-of-task security activity unexpectedly passed"
  exit 1
fi

cat > "$PROJECT/control/SECURITY_SCOPE.yaml" <<'EOF'
schema_version: 1
authorized_security_testing: false
default_posture: defensive-only
allowed_activities:
  - inventory
  - exposure_review
  - configuration_review
  - patch_verification
  - hardening
prohibited_activities:
  - exploit_validation
rules_of_engagement_ref: ""
approval_ref: ""
evidence_handling: redact-sensitive-data
notes: "Synthetic restrictive test scope."
EOF

"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null
if "$ROOT/bin/sys-preflight" "$PROJECT" --action-class security_test --activity exploit_validation >/dev/null 2>&1; then
  echo "exploit_validation unexpectedly passed under restrictive scope"
  exit 1
fi

echo "test_security_scope.sh: PASS"

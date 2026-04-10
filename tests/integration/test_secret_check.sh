#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-secret.XXXXXX")"
PROJECT="$TMP_ROOT/SecretNode"

"$ROOT/bin/sys-init" SecretNode --path "$PROJECT" --no-refresh

cat > "$PROJECT/control/CREDENTIAL_REFERENCES.yaml" <<'EOF'
schema_version: 1
secret_storage_policy: references-only-no-raw-secrets
references:
  - name: test-env-secret
    purpose: integration test reference
    ref: env:SACST_SECRET_CHECK_TEST
    scope: test
    rotation_note: synthetic only
EOF

SACST_SECRET_CHECK_TEST=present "$ROOT/bin/sys-secret-check" "$PROJECT" >/dev/null

if "$ROOT/bin/sys-secret-check" "$PROJECT" --ref env:SACST_SECRET_CHECK_TEST >/dev/null 2>&1; then
  echo "empty env ref unexpectedly passed"
  exit 1
fi

"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null

echo "test_secret_check.sh: PASS"

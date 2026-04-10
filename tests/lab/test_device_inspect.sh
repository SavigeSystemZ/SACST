#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

if [ -z "${SACST_LAB_PROJECT:-}" ] || [ -z "${SACST_LAB_DEVICE:-}" ]; then
  echo "SKIP: set SACST_LAB_PROJECT and SACST_LAB_DEVICE to run lab device inspection"
  exit 0
fi

"$ROOT/bin/sys-refresh" "$SACST_LAB_PROJECT" --device "$SACST_LAB_DEVICE" --output-scope device
"$ROOT/bin/sys-validate" --project "$SACST_LAB_PROJECT"

echo "test_device_inspect.sh: PASS"

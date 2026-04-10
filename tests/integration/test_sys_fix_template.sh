#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

"$ROOT/bin/sys-fix" --template >/dev/null

echo "test_sys_fix_template.sh: PASS"

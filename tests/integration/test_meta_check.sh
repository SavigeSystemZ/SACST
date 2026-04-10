#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

"$ROOT/bin/sys-meta-check" >/dev/null

echo "test_meta_check.sh: PASS"

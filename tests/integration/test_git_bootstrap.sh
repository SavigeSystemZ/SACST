#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-git.XXXXXX")"
PROJECT="$TMP_ROOT/GitNode"

"$ROOT/bin/sys-init" GitNode --path "$PROJECT" --no-refresh
"$ROOT/bin/sys-git-bootstrap" "$PROJECT"

test -d "$PROJECT/.git"
REMOTE_URL="$(git -C "$PROJECT" remote get-url origin)"
test "$REMOTE_URL" = "git@github.com:SavigeSystemZ/GitNode.git"
test "$(git -C "$PROJECT" config user.name)" = "Michael Spaulding"
test "$(git -C "$PROJECT" config user.email)" = "mtspaulding87@gmail.com"

echo "test_git_bootstrap.sh: PASS"

#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sacst-windows.XXXXXX")"
PROJECT="$TMP_ROOT/WindowsNode"
SOURCE="$ROOT/tests/fixtures/windows-desktop/minimal/raw-audit/20240104T000000Z"

"$ROOT/bin/sys-init" WindowsNode --path "$PROJECT" --platform windows-desktop --no-refresh
"$ROOT/bin/sys-refresh" "$PROJECT" --source "$SOURCE"

grep -q 'platform: windows-desktop' "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q 'hostname: WINNODE' "$PROJECT/context/normalized/HOST_PROFILE.md"
grep -q 'Windows 11 Pro' "$PROJECT/context/normalized/OS_AND_KERNEL.md"
grep -q 'Windows security collector' "$PROJECT/context/normalized/SECURITY_POSTURE.md"
"$ROOT/bin/sys-validate" --project "$PROJECT" >/dev/null

echo "test_normalize_windows.sh: PASS"

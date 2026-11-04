#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$ROOT/scripts/verify_formal.sh"
"$ROOT/scripts/verify_godot.sh"
"$ROOT/scripts/verify_live.sh"
echo "ALL HEADLESS VERIFICATION GATES PASSED"

#!/usr/bin/env bash
# Godot may return 0 after a GDScript load failure, so diagnostics are fatal too.
set -u -o pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ -n "${GODOT:-}" ]; then
  engine="$GODOT"
elif command -v godot >/dev/null 2>&1; then
  engine="$(command -v godot)"
elif [ -x "$ROOT/.tools/godot" ]; then
  engine="$ROOT/.tools/godot"
else
  echo "BLOCKED: Godot 4 executable not found; set GODOT=/absolute/path/to/godot" >&2
  exit 2
fi
mkdir -p "$ROOT/test-results"
failed=0
run_check() {
  local name="$1"
  shift
  local log="$ROOT/test-results/$name.log"
  set +e
  "$engine" --headless --path "$ROOT" "$@" >"$log" 2>&1
  local status=$?
  set -e
  cat "$log"
  if [ "$status" -ne 0 ] || grep -E 'SCRIPT ERROR|ERROR:|FAIL:' "$log"; then
    echo "$name: FAIL (engine exit $status; diagnostics are fatal)" >&2
    failed=1
  else
    echo "$name: PASS (engine exit 0, no error diagnostics)"
  fi
}
run_check import --editor --import --quit
run_check mechanics --script res://tests/test_runner.gd
exit "$failed"

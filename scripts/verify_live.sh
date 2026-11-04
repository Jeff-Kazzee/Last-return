#!/usr/bin/env bash
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
mkdir -p "$ROOT/artifacts/live"
log="$ROOT/artifacts/live/headless-driver.log"
set +e
"$engine" --headless --path "$ROOT" --fixed-fps 60 --script res://tests/live_playtest.gd >"$log" 2>&1
status=$?
set -e
cat "$log"
if [ "$status" -ne 0 ] || grep -E 'SCRIPT ERROR|ERROR:|FAIL:' "$log"; then
  echo "live application: FAIL (engine exit $status; diagnostics are fatal)" >&2
  exit 1
fi
python3 - "$ROOT/artifacts/live/report.json" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as handle:
    report = json.load(handle)
required = {
    "result": "PASS",
    "duel_score": [5, 0],
    "pause_checked": True,
    "pause_frozen": True,
    "breach_exit_open": True,
    "breach_completed": True,
}
for key, expected in required.items():
    if report.get(key) != expected:
        raise SystemExit(f"live application: FAIL {key}: expected {expected!r}, got {report.get(key)!r}")
if report.get("player_strikes", 0) < 1:
    raise SystemExit("live application: FAIL no measured active strike")
print("live application: PASS (input-only duel, pause, breach, and exit; no forced game state)")
PY

#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${LAST_RETURN_WEB_PORT:-8090}"
ARTIFACTS="$ROOT/artifacts/web"
mkdir -p "$ARTIFACTS"
scripts/build_web.sh
if [ ! -d "$ROOT/web/node_modules/playwright-core" ]; then
  npm ci --prefix "$ROOT/web" --no-audit --no-fund
fi
if [ -z "${CHROMIUM_PATH:-}" ]; then
  for candidate in /usr/bin/chromium /usr/bin/chromium-browser /usr/bin/google-chrome; do
    if [ -x "$candidate" ]; then export CHROMIUM_PATH="$candidate"; break; fi
  done
fi
test -n "${CHROMIUM_PATH:-}" || { echo "BLOCKED: Chromium is not installed" >&2; exit 2; }
python3 "$ROOT/scripts/serve_web.py" --port "$PORT" > "$ARTIFACTS/server.log" 2>&1 &
server_pid=$!
cleanup() {
  kill "$server_pid" 2>/dev/null || true
  if [ -n "${xvfb_pid:-}" ]; then kill "$xvfb_pid" 2>/dev/null || true; fi
}
trap cleanup EXIT
sleep 0.5
if [ -z "${DISPLAY:-}" ] || ! xdpyinfo >/dev/null 2>&1; then
  display=":$((120 + RANDOM % 20))"
  Xvfb "$display" -screen 0 1280x720x24 -nolisten tcp -ac > "$ARTIFACTS/xvfb.log" 2>&1 &
  xvfb_pid=$!
  export DISPLAY="$display"
  sleep 0.5
fi
export LIBGL_ALWAYS_SOFTWARE=1
export LAST_RETURN_WEB_URL="http://127.0.0.1:$PORT/"
export LAST_RETURN_WEB_ARTIFACTS="$ARTIFACTS"
NODE_PATH="$ROOT/web/node_modules" node "$ROOT/tests/web_smoke.js"
echo "WEB BROWSER PASS: title, duel, pause, WebGL2, cross-origin isolation"

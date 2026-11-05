#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ -n "${GODOT:-}" ]; then
  engine="$GODOT"
elif command -v godot >/dev/null 2>&1; then
  engine="$(command -v godot)"
elif [ -x "$ROOT/.tools/godot" ]; then
  engine="$ROOT/.tools/godot"
else
  echo "BLOCKED: Godot 4.4.1 executable not found; set GODOT=/absolute/path/to/godot" >&2
  exit 2
fi
"$engine" --headless --path "$ROOT" --editor --import --quit
rm -rf "$ROOT/build/web"
mkdir -p "$ROOT/build/web"
"$engine" --headless --path "$ROOT" --export-release Web "$ROOT/build/web/index.html"
cp "$ROOT/web/_headers" "$ROOT/build/web/_headers"
cp "$ROOT/web/sandbox_polyfill.js" "$ROOT/build/web/sandbox_polyfill.js"
python3 - "$ROOT/build/web/index.html" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
html = path.read_text()
needle = '<script src="index.js"></script>'
if needle not in html:
    raise SystemExit("Web shell entry point not found")
html = html.replace(needle, '<script src="sandbox_polyfill.js"></script>\n' + needle, 1)
path.write_text(html)
PY
# The release export is deterministic enough for a same-origin static package,
# but the copied deployment metadata is the Cloudflare Pages contract.
required=(index.html index.js index.wasm index.pck _headers)
for file in "${required[@]}"; do
  test -s "$ROOT/build/web/$file" || { echo "Web build missing $file" >&2; exit 1; }
done
if grep -q 'GODOT_THREADS_ENABLED = true' "$ROOT/build/web/index.html"; then
  echo "Web build unexpectedly uses threaded templates." >&2
  exit 1
fi
echo "Web build is non-threaded and runs in an opaque-origin iframe without COOP/COEP."
du -sh "$ROOT/build/web"
echo "WEB BUILD PASS: $ROOT/build/web"

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
# The release export is deterministic enough for a same-origin static package,
# but the copied deployment metadata is the Cloudflare Pages contract.
required=(index.html index.js index.wasm index.pck _headers)
for file in "${required[@]}"; do
  test -s "$ROOT/build/web/$file" || { echo "Web build missing $file" >&2; exit 1; }
done
if grep -qE 'SharedArrayBuffer|thread' "$ROOT/build/web/index.js" 2>/dev/null; then
  echo "Web build uses threaded templates; COOP/COEP headers are included."
fi
du -sh "$ROOT/build/web"
echo "WEB BUILD PASS: $ROOT/build/web"

#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${CLOUDFLARE_PAGES_PROJECT:-last-return}"
if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
  echo "BLOCKED: CLOUDFLARE_API_TOKEN is not present in this environment." >&2
  echo "The connected account is not exposed to this cloud worker. Export a scoped Pages token only for this deployment, or run this script locally." >&2
  exit 2
fi
cd "$ROOT"
"$ROOT/scripts/build_web.sh"
WRANGLER=(npx --yes wrangler@4.42.2)
if ! "${WRANGLER[@]}" pages project create "$PROJECT" --production-branch main; then
  echo "Pages project may already exist; continuing to direct upload."
fi
"${WRANGLER[@]}" pages deploy "$ROOT/build/web" --project-name "$PROJECT" --branch main --commit-dirty=true

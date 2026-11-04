# Web release verification

**Branch:** `feat/verified-core-duel`  
**Godot:** 4.4.1 stable (`49a5bc7b6`), Compatibility renderer, threaded Web template  
**Build:** `scripts/build_web.sh`  
**Browser gate:** `scripts/test_web.sh`

## Results

- Web export: **PASS**; `index.html`, JavaScript, 40 MB WebAssembly, PCK, and Cloudflare `_headers` were produced.
- Local browser: **PASS** with WebGL2 and `crossOriginIsolated=true`.
- The canvas reached 1280×720. Enter reached the live duel, movement input was delivered, and Escape reached pause.
- Title, duel, and pause screenshots had three distinct SHA-256 hashes.
- No page errors or failed requests were recorded.
- The same browser gate was run against a temporary HTTPS Cloudflare Quick Tunnel. Public requests returned HTTP 200 and `application/wasm`; COOP/COEP headers were present; the game booted, entered a duel, moved, and paused.
- Evidence: `docs/verification/web-gate.json`, `captures/web-title.png`, `captures/web-duel.png`, and `captures/web-pause.png`.

## Account deployment status

**NOT DEPLOYED TO CLOUDFLARE PAGES.** The worker has no Cloudflare credential:

```text
wrangler whoami -> You are not authenticated
```

No `CLOUDFLARE_API_TOKEN`, account ID, Wrangler config, or Cloudflare toolkit is exposed. The deployment script deliberately exits 2 rather than pretending to deploy. The Quick Tunnel proves the exported artifact works through Cloudflare's public edge, but it is temporary and is not the owner's Pages project.

To complete the durable deployment, provide a scoped Cloudflare Pages token only through the trusted environment and run:

```bash
CLOUDFLARE_API_TOKEN=... CLOUDFLARE_ACCOUNT_ID=... scripts/deploy_cloudflare.sh
```

Do not paste a token into source, screenshots, chat logs, or this repository.

## Limits

- Browser testing used Chromium with software WebGL under Xvfb. It is not a GPU performance benchmark.
- Firefox, Safari, mobile touch controls, audio, and human playtesting remain unverified.
- The build is still the verified duel + breach slice; it is not the proposed 64-encounter campaign.
- No analytics, telemetry, leaderboard, login, or cloud save is present.

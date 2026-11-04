# Web release and Cloudflare deployment

## Current status

The Godot web export builds and runs in Chromium with WebGL2 and cross-origin isolation. The browser smoke gate verifies title → duel → pause input and distinct rendered states. The same gate passed against a temporary public Cloudflare Quick Tunnel URL: Cloudflare returned `200`, `application/wasm`, COOP/COEP, and the game reached the live duel and pause states.

A permanent Cloudflare Pages deployment on the owner's account is **not yet claimed** because this cloud worker has no Cloudflare credential:

- `wrangler whoami` reports `You are not authenticated`.
- No `CLOUDFLARE_API_TOKEN`, account ID, Wrangler config, or Cloudflare toolkit is exposed.
- The application and deployment package are ready; account authentication is the remaining external blocker.
- The temporary Quick Tunnel is not a durable production deployment and disappears when this worker stops.

Do not put a Cloudflare token in the repository, a commit, screenshot, or chat log.

## Build locally

Requires Godot 4.4.1 and its matching export templates.

```bash
scripts/build_web.sh
python3 scripts/serve_web.py --port 8090
# open http://127.0.0.1:8090/
```

The export is `build/web/` and is intentionally ignored by Git. It contains `index.html`, JavaScript, WebAssembly, PCK, and the Cloudflare `_headers` contract.

The web preset uses Godot's threaded Web template, so the host must return:

```text
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

Without both headers, browsers cannot provide the shared memory the threaded runtime needs. `web/_headers` is copied into the build for Cloudflare Pages. `scripts/serve_web.py` sends the same isolation headers for local verification.

## Browser verification

```bash
scripts/test_web.sh
```

This builds the export, serves it with production headers, launches Chromium under Xvfb with software WebGL, and verifies:

- the document and Godot 4.4.1 web runtime boot;
- WebGL2 is available;
- `crossOriginIsolated` is true;
- the canvas sizes to 1280×720;
- Enter reaches the live duel and Escape reaches pause;
- title, duel, and pause screenshots have distinct hashes;
- no page errors or failed requests occur.

The browser suite is not a human playtest, mobile test, GPU benchmark, or proof of every input path.

## Deploy to Cloudflare Pages

Required account setup:

1. Create a Cloudflare API token with **Cloudflare Pages: Edit** for the intended account.
2. Export it only in the trusted deployment environment:

```bash
export CLOUDFLARE_API_TOKEN='<scoped token>'
export CLOUDFLARE_ACCOUNT_ID='<account id>'
export CLOUDFLARE_PAGES_PROJECT='last-return'
scripts/deploy_cloudflare.sh
```

The script builds from the checked-out revision, creates the Pages project if needed, and directly uploads `build/web/` to the `main` Pages branch. Record the immutable deployment URL and production URL from Wrangler's output.

Alternative: configure a Cloudflare Pages project to deploy a prebuilt `build/web/` directory from owner-controlled CI. Do not commit build outputs or credentials. A GitHub Actions deployment would require repository secrets and workflow-file installation by the owner; the current cloud GitHub App cannot create workflow files.

## Production checks after deployment

- Confirm the production URL returns HTML, JavaScript with a JavaScript MIME type, and `application/wasm` for the WebAssembly file.
- Confirm both COOP and COEP headers on `/`, `/index.js`, `/index.wasm`, and `/index.pck`.
- Load the URL in a normal browser and record title → duel → pause → retry.
- Test Chrome, Firefox, and Safari where available; test a phone separately.
- Record build SHA, deployment ID, production URL, browser versions, and known limitations.
- A successful static upload is not a Windows release, human playtest, or proof of sustained performance.

## Known web limitations

- Mouse and keyboard controls are primary; touch/mobile controls are not implemented yet.
- No audio assets are present.
- Progress is not persisted.
- The current game is a first-to-three duel with rally escalation, PERFECT timing, focus BRAKE, bank pylons, adaptive rival play, and a two-lock breach—not the full 64-encounter campaign.
- Threaded WebAssembly requires cross-origin isolation, which some embed contexts disallow.
- No Windows export, online leaderboard, telemetry, or runtime AI service is included.

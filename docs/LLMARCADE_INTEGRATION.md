# LLM Arcade integration

**Date:** 2026-11-05
**Platform:** https://www.llmarcade.fun
**Organization repo:** https://github.com/LLM-Arcade/llm-arcade
**Integration branch:** `feature/last-return-game` (from `dev`)
**Local integration commit:** `bab1e60043ed2f1d4dabcb26e150d1ee4a181ae5`

## Implemented integration

- Added Last Return as a Track-A cabinet with a Godot 4.4.1 Compatibility build under `public/games/last-return/`.
- Added `src/games/last-return/LastReturn.tsx`, an opaque-origin iframe bridge that accepts score and achievement messages only from the cabinet frame.
- Registered `last-return` in `src/games/registry.ts`; `/dev/last-return` is immediately playable in development.
- Added the launch-lineup entry and a 512×512 key-art tile. The tile is a temporary crop from a verified gameplay capture, not approved generated key art.
- Added `src/games/last-return/LastReturn.tsx` message forwarding for `ARCADE_SCORE` and `ARCADE_ACHIEVEMENT`; Godot emits `ARCADE_READY` on boot.
- Added `db/seed-last-return.sql` with seven achievements and `db/publish-last-return.sql`. Neither SQL file has been executed because this worker has no Supabase administrative credential.
- Added `scripts/harness/last-return.mjs` and included it in `pnpm test:games`.

## Platform boundary findings

- LLM Arcade mounts Track-B cabinets in `sandbox="allow-scripts"`. That produces an opaque origin.
- The original threaded Godot export failed in that sandbox. The working cabinet uses the non-threaded Web template.
- Opaque-origin fetches send `Origin: null`; WASM/PCK must return `Access-Control-Allow-Origin: *`. This is scoped to `/games/last-return/(.*)` in `vercel.json` and to local Vite development.
- Godot's optional PWA probe throws a sandbox SecurityError when it reads `navigator.serviceWorker`. `sandbox_polyfill.js` replaces only that unavailable probe; it does not install a service worker.
- The game fetches no network resources after loading and retains its own 1280×720 rendering/scaling behavior inside the cabinet frame.

## Verification actually run

- `pnpm install --frozen-lockfile`: PASS after temporary sandbox TLS workaround.
- `pnpm run ci`: PASS, including lint, typecheck, production Vite build, existing game harnesses, new Last Return integrity harness, and safe-next.
- Vite `/dev/last-return` in Chromium: PASS. One sandboxed iframe mounted, Godot 4.4.1 booted with WebGL2, `ARCADE_READY` arrived, Enter started a live duel, and synthetic `ARCADE_SCORE`/`ARCADE_ACHIEVEMENT` messages were forwarded by the React bridge.
- The `dist/` production build contained the cabinet WASM and PCK.
- No human playtest or owner approval is claimed.

## Repository access boundary

- The org repository is publicly readable to this worker, and local CI/browser tests pass.
- `git push` to `LLM-Arcade/llm-arcade` is rejected with HTTP 403 by the active `cline-cloud[bot]` installation token. The live installation endpoint still lists only `Jeff-Kazzee/Last-return`.
- The integration commit therefore remains local at `bab1e60043ed2f1d4dabcb26e150d1ee4a181ae5`; a 9.3 MB git bundle and a 15 MB patch were generated under `artifacts/` as recovery artifacts.
- To publish it, start a Cline task from `LLM-Arcade/llm-arcade` after the organization installation has granted that specific repository, or push the bundle from an owner-authenticated clone:
  ```bash
  git fetch /path/to/llm-arcade-last-return.bundle feature/last-return-game
  git push origin feature/last-return-game
  ```

## Remaining production steps

1. Push `feature/last-return-game` and open a PR into `dev`.
2. Run the protected `check` job and a Vercel preview browser playtest at `/dev/last-return`.
3. Apply `db/seed-last-return.sql` through the owner-approved Supabase SQL process.
4. Release `dev` to `prod` per `docs/BRANCH-WORKFLOW.md`, then apply `db/publish-last-return.sql` after owner playtest approval.
5. Verify `/game/last-return` on `llmarcade.fun` as a fresh guest and signed-in player.

A 42 MB Godot WASM is part of the cabinet. Vercel compresses it in transit; no GPU/performance claims have been measured on the production edge.

Recovery artifacts produced from the local integration branch:

- `/workspace/artifacts/llm-arcade-last-return.bundle`
- `/workspace/artifacts/llm-arcade-last-return.patch`

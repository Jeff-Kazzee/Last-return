# Implementation progress

## 2026-11-04 — discovery and baseline

- Branch `feat/verified-core-duel` created from `origin/dev` at `6365c1eb955b1e9053df73db73f81488759b6711`; worktree had no project or game tests.
- Read `AGENTS.md`, `docs/GAME_DESIGN.md`, `docs/CLINE_OVERNIGHT_PROMPT.md`, branching/release rules, and PR template. The requested `.cline` and verification/reference files are absent from `dev`; exact copies were inspected read-only from remote `origin/chore/cline-skills-verification` (PR #6), without merging or copying that branch into this change.
- Skill discovery: no `SKILL.md`, Matt Pocock, poteto, T-Stack, personal verification skill, or provider-backed council/Sol CLI was found under `/workspace`, `/root`, `/home`, `/opt`, or `/usr/local/share`; the active session exposes no discovered Cline skills. Read the remote project skill text and use its verification/full-stop/file-pr workflow as a documented fallback, not as a claim of skill installation or invocation.
- Tooling: installed official Godot `4.4.1.stable.official.49a5bc7b6` locally under ignored `.tools/`; executable SHA-256 `54215149d52efb1d653a3dec39d0993587bdf5daa2c56e787b5ee88417fb1339`. Python 3.11.2, `gh`, Xvfb, and xdotool are available. `DISPLAY=:99` was not active; rendered checks can use an isolated `xvfb-run` display.
- GitHub protection API checks for `dev` and `prod` returned HTTP 403 to this integration. No settings were changed. The documented owner-only PR gates remain authoritative.
- Baseline oracle: no `project.godot` exists, so a playable import/gameplay check fails by absence. Expected first behavior and stable checks are defined in `docs/IMPLEMENTATION_PLAN.md` and `formal/README.md`.

## Lifecycle oracle and GDScript bridge

- Added an explicit finite state-machine specification and bounded-exhaustive Python checker, including rejected events, progress tokens, retry reset, and an intentional duplicate-goal mutation.
- Executed `scripts/verify_formal.sh`: clean model PASS with 932 states and 8,388 transitions; intentional duplicate-goal mutation produced exit 1 and trace `start → goal_player → goal_player`; wrapper exit 0. Python compilation and `git diff --check` passed.
- Preserved the formal oracle in commit `4cd330059d2bb1c9714634f45192a37c0be27d88`.
- Runtime red baseline: `godot --headless --path /workspace --script res://tests/test_runner.gd` exited 1 because `duel_rules.gd` was absent. Added only the public lifecycle implementation, reran the unchanged suite: 45 checks, 0 failures. Headless editor import also exited 0.
- Added the fixed-step duel simulation and 35 public physics/AI checks. Initial run: 76/80 passed. Traced and fixed an AI reaction off-by-one (150 ms now means 18 ticks); the unchanged AI test passed while only the three contact-fixture assertions remained red. Corrected passive/active fixtures that stopped 4 px short of contact; all 80 checks then passed. No evaluator assertion was weakened.
- Deterministic evidence: identical seed/input trace for 15 seconds; held-out seeds 7, 19, 43, 101, 509, 1021, 7919, 65537 for 20 seconds each; maximum-speed rail/paddle, exact tie, goal-edge, pause-at-impact, retry, AI speed/acceleration/reaction, and stationary-defender checks all green.
- Preserved duel simulation in commit `0da65ba800e7cfd267daf915a6fd2e45ef2cc0c4`.
- Added the breach simulation and 23 checks. One initial fixture left the courier inside the closed exit; after moving that fixture away before target destruction, all 103 total checks passed. Enemy ownership rejects armor, real timed paddle ownership breaks it, the open exit requires entry, body damage/invulnerability/failure/retry, pause, maximum-speed contact, sidearm non-bypass, and deterministic traces are green.
- Added `scripts/verify_godot.sh`; both engine exit status and `SCRIPT ERROR`/`ERROR`/`FAIL` diagnostics are fatal because an observed GDScript compile failure could otherwise exit 0. Headless import and mechanics both pass under this wrapper.
- Preserved the breach milestone in commit `658b6b1d841a237e70777109835afe8fe29ad078`.

## Playable application and empirical tuning

- Added the title → duel → connected breach → departure flow, custom high-contrast presentation, keyboard/mouse/gamepad input map, focus/disconnect pause, retry, debug view, reduced-effects mode, and real scene integration tests.
- Added an input-only application driver. No game state is assigned by the driver. Failures and traces remain in ignored `artifacts/`; the final driver uses `live-v3-recovery-actions`.
- Tuning round 1: fixed a real swept-overlap defect in which a departing overlap was treated as a new collision. The unchanged live workload dropped from 1,585 to 16 player-return events, and pause comparison became exact after correcting sampler timing.
- Tuning round 2: enforced a 55% minimum forward component on paddle returns after a strengthened test exposed 32% near-vertical pacing stalls. Speed and cap are preserved; meaningful angled banks remain possible.
- Tuning round 3: reduced introductory-rival movement to 200 and widened prediction error to ±95 after the unchanged bot reached only 4–1 at 180 simulated seconds. Final public-edge AI speed/acceleration/reaction tests pass.
- Final headless gates: formal 932 states / 8,388 transitions plus expected mutation failure; Godot 121 checks / 0 failures; input-only route 5–0 duel in 103.875 s, 14 strikes, exact pause freeze, breach target and exit completed in 8.225 s with 3 health.
- Rendered route also completed under isolated Xvfb/Mesa. Captures are being archived under `docs/verification/captures/`; they are visual evidence, not performance or human-playtest claims.
- Added `scripts/verify_all.sh`, `scripts/verify_live.sh`, and a pinned CI proposal at `docs/verification/game-verification.workflow.yml`. The cloud GitHub App rejected a push containing `.github/workflows/game-verification.yml` because it lacks `workflows` permission; the workflow was moved to the documented owner-installation path rather than weakening or bypassing credentials. No branch protection or repository setting was modified.
- One same-harness independent review was requested but blocked by the reviewer provider usage limit before findings. No skill invocation or multi-provider review is claimed.

## Web release preparation

- Added a pinned Godot 4.4.1 Web export preset, Cloudflare `_headers`, local isolation-header server, web build/deploy scripts, and a Chromium WebGL2 smoke gate.
- Web export: **PASS**, 41 MB package with WASM, PCK, JavaScript, and Cloudflare headers.
- Browser gate: **PASS** at 1280×720; Godot 4.4.1 booted, WebGL2 and cross-origin isolation were active, Enter reached a live duel, movement was accepted, Escape reached pause, and title/duel/pause hashes were distinct.
- Deployed the exact build to a temporary Cloudflare Quick Tunnel for external testing: public HTTP 200, `application/wasm`, COOP/COEP headers, and browser gate **PASS** through the public URL. This is deliberately not described as an account Pages deployment.
- Permanent Pages deployment is blocked because no Cloudflare credential is exposed to the worker. `scripts/deploy_cloudflare.sh` exits 2 with a clear message unless a scoped `CLOUDFLARE_API_TOKEN` is supplied. No token was requested in chat or committed.
- Evidence: `docs/verification/web-gate.json`, `docs/verification/captures/web-title.png`, `web-duel.png`, and `web-pause.png`.

## Intensity and depth pass

- The previous expert input benchmark won an uncontested 5–0 match in roughly 104 seconds. Changed the arcade match to first-to-three and expanded the core loop instead of merely increasing raw AI speed.
- Added rally acceleration on every paddle return, PERFECT/ACTIVE/PASSIVE timing grades, focus generated by returns, a player BRAKE that slows the core while preserving courier movement, two bankable mid-court pylons, pressure-wide goals after six exchanges, and a rival that gains speed/reaction/accuracy after every conceded goal.
- The breach now requires two distinct lock hits at different court positions. The first returned shot exposes the second lock but does not open the exit.
- Added regression coverage for rally escalation and cap, pylon rebound, PERFECT vs active grading, BRAKE energy/movement effect, pressure-wide conversions, adaptive rival motion bounds, two-lock ownership, retry, and pause.
- Final expert input benchmark: **3–2 win in 90.28 simulated seconds**, 23 PERFECT returns, 8 BRAKE activations, longest rally 17, then two-lock breach completed in 11.38 seconds. This is materially different from the former 5–0 walkover; no game state is forced by the driver.
- Formal lifecycle revised to the shipped first-to-three rule: exhaustive graph now has **324 states / 2,916 transitions**, and the intentional duplicate-goal mutation still fails with a counterexample.
- Godot suite: **135 checks / 0 failures** at this stage.
- Rebuilt the Web export and reran the Chromium WebGL2 gate locally and through the public Cloudflare preview: **PASS**, with the new pylons and focus HUD visible and title/duel/pause states distinct.

## Known unverified behavior

Physical controller hardware, human mouse-aim play, Windows export and runtime, audio, human comprehension/fun, accessibility testing with users, frame-time/GPU performance, long-session stability, and continuous physics outside the finite test scenarios remain unverified. The formal abstraction does not cover runtime fault recovery or continuous motion. The branch is ready for owner review only; it is not merged or release-approved.

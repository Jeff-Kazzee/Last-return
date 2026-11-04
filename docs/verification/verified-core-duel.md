# Verification record — verified core duel

**Base SHA:** `6365c1eb955b1e9053df73db73f81488759b6711`  
**Branch:** `feat/verified-core-duel`  
**Candidate SHA:** recorded in the PR after the final documentation commit; all checks below were rerun on the implementation revision immediately before handoff.
**Environment:** Linux, Python 3.11.2, Godot 4.4.1 stable (`49a5bc7b6`), GDScript, Compatibility renderer.

## Claims, oracles, and stable fixtures

See `docs/IMPLEMENTATION_PLAN.md` and `formal/README.md` for the pre-implementation behavior contract. The initial baseline contains no Godot project, implementation, or tests. Each result below must be observed, not inferred.

## Formal model

- Command: `scripts/verify_formal.sh` (runs `python3 formal/check_duel_model.py` and `python3 formal/check_duel_model.py --mutate duplicate-goal`).
- Bounds: scores 0–5, four phases, binary pause and clock/puck/AI tokens; exhaustive reachable-state exploration, 100,000-state safety cap, no depth cutoff.
- Assumptions: first to five, no win-by-two, goal events represent already validated geometry, automatic timers are authorized explicit events, no continuous physics claim.
- Result (working tree before lifecycle implementation): **PASS**. Clean exploration visited **932 states / 8,388 action transitions**; model SHA-256 `92a00ad915f290df93f7d03a15a0b53704741f32fd9bac882cb7ad1e8731b808`; exit 0. The `duplicate-goal` mutation exited 1 at 10 states / 38 transitions with `unpaused LIVE is the only scoring source` and trace `start → goal_player → goal_player` (score 1 became 2 during `GOAL_FREEZE`). `scripts/verify_formal.sh` then exited 0 because the negative control was detected as required.

## Godot import and runtime bridge

- Planned command: `/workspace/.tools/godot --headless --path /workspace --editor --import --quit`.
- Command: `/workspace/.tools/godot --headless --path /workspace --script res://tests/test_runner.gd`.
- Lifecycle red baseline: missing `res://scripts/simulation/duel_rules.gd`, test command exit 1.
- Lifecycle candidate result: **PASS — 45 checks, 0 failures**, test command exit 0. Covers initialization, start, both score attributions, duplicate goals, pause/resume, frozen clocks/timers, legal serve, fifth-goal finish, rejected finished-state restarts, complete retry, and automatic authorized transitions.
- Headless import result at this milestone: **PASS**, editor import command exit 0 with no parser errors.

## Continuous physics and AI

Finite samples are not proof for all floating-point inputs. The fixed oracle is `tests/duel_physics_test.gd`, executed through the Godot test command above.

- Result at the duel simulation milestone: **PASS — 80 total checks, 0 failures** (45 lifecycle + 35 duel physics/AI).
- Deterministic workload: two independent simulations, seed 90210, identical blank inputs, 1,800 ticks at 1/120 s, snapshots compared every 30 ticks: identical.
- Held-out workload: seeds 7, 19, 43, 101, 509, 1021, 7919, 65537; 2,400 ticks each at 1/120 s; score bounds and speed cap held in every sampled tick.
- Adversarial cases: analytic sweep vs naive end-overlap negative control; maximum-speed (1,050 units/s) top rail and paddle crossing; exact rail/paddle tie; active aim/pace cap; both goal attributions; post graze and closed side rail; duplicate crossing; pause immediately before impact; retry; AI displacement/acceleration/reaction; stationary defender for up to 120 simulated seconds.
- Red/green record: initial implementation 76/80. AI 18-tick off-by-one fixed and unchanged test passed. Three remaining assertions traced to passive/active fixtures ending 4 px before paddle contact; starting distance corrected for both without changing assertions. Final unchanged behavior suite 80/80.

## Breach simulation

- Initial breach milestone: **PASS — 103 total checks, 0 failures** under `scripts/verify_godot.sh`; headless import also passed with no error diagnostics. The final suite below includes later movement, body, sidearm-stun, and disconnect additions.
- Ownership chain: enemy-owned target impact rejected; real active paddle contact changed ownership to player; that returned shot broke the mechanism; target break opened but did not itself complete the exit; entering the open exit completed the room.
- Additional cases: closed-exit rejection, maximum-speed target sweep, full-state pause, three discrete body hits with invulnerability, failure and complete retry, sidearm armor non-bypass, and identical five-second breach traces.
- Harness integrity: Godot emitted a GDScript compile error while exiting 0 during development; `scripts/verify_godot.sh` now fails on engine errors as well as nonzero status. No such diagnostics remain in the passing run.

## Final Godot suite and gameplay tuning

- Command: `scripts/verify_godot.sh`. Result: **PASS — 121 checks, 0 failures**, with headless import diagnostics clean. Composition includes 45 lifecycle checks, expanded duel physics/AI/movement checks, breach ownership/damage/sidearm checks, and scene transition/focus/disconnect checks.
- The suite now checks overlap departure, 55% minimum forward travel on paddle returns, dash bounds/cooldown, weak body blocks, sidearm sentry stun, controller-disconnect pause, and the opened-exit transition.
- Input-driven application command: `scripts/verify_live.sh`. Result: **PASS**, score 5–0, 14 active strikes, 103.875 simulated seconds, exact pause snapshot, breach completed with 3 health in 8.225 seconds, no fault resets. The driver assigns no score, position, projectile, target, health, or exit state; it uses only public Input actions and scene flow.
- Tuning evidence: the first input run timed out at 3–1 and reported 1,585 player-return events. A focused overlap regression exposed that a departing overlap produced repeated contacts; fixing it reduced the same workload to 16 returns, then 25 after forward-pace tuning. The introductory rival was tuned to 200 movement speed and ±95 prediction error while retaining the 18-tick observation delay. The final unchanged `live-v3` input workload wins 5–0 and completes the breach. These finite results do not establish general balance.

## Real rendered application and visual checks

- Environment: isolated Xvfb, Mesa llvmpipe, OpenGL Compatibility, Godot 4.4.1. The final gameplay code was launched as the real `main.tscn` and completed the input-only duel → breach → departure route in a rendered run. Its retained summary is `docs/verification/rendered-route-summary.json`. The old asynchronous capture recorder repeated paths and sampled pause before the pause physics step settled; that summary therefore records `pause_frozen=false`. This is a render-harness limitation, not evidence that pause advances the simulation: the corrected `live-v3` headless gate measured the exact complete snapshot unchanged. No gameplay state was changed between those runs.
- Visual-state captures under `docs/verification/captures/` came from a separate real-render presentation pass that deliberately staged states for inspection. They are visual evidence only, as documented in that directory. Separate actual X11 `xdotool` Enter/D/Escape input reached title → duel → paused state.
- A screenshot supports visual observation only, not mechanics or human comprehension. The render cadence is not a performance benchmark; software rendering ran far slower than real time while physics remained at 1/120 s. No frame-time or GPU claim is made.

## Review, skill discovery, and limitations

- Cline did not discover repository T-Stack skills in this session. The exact remote skill/verification text from `origin/chore/cline-skills-verification` was read as a fallback. No installed skill was invoked.
- No Matt Pocock, poteto/Lauren, personal verification skill, Sol CLI, or distinct-provider council was found. `full-stop` semantics were followed manually; no provider-backed review is claimed.
- One independent same-harness reviewer was requested after the implementation stabilized, but the reviewer provider returned a usage-limit error before producing findings. **Independent review: NOT RUN/BLOCKED.**
- The formal model covers the discrete lifecycle only. Continuous physics, rendering, input delivery, AI quality, and the runtime fault-recovery shortcut (LIVE → READY re-serve) are outside its checked scope. The runtime bridge tests cover the required lifecycle actions, but do not turn the abstraction into a proof of all Godot states.
- Physical controller hardware, mouse aiming through a human-controlled viewport, accessibility with real users, audio, Windows export/runtime, long-session performance, human fun, and sustained balance are **NOT VERIFIED**.
- No Windows export templates were installed; no export was produced. No save, campaign, boss, or trial feature is implemented.
- No voice/audio assets are present. No unlicensed art or runtime AI service was added.
- The repository protection API was inaccessible to the integration (HTTP 403). No settings, protections, branches, tokens, or production state were changed. The PR remains unmerged for owner review.

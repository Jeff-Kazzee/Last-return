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
- Next: preserve this simulation milestone and add the connected breach with return-ownership and room-reset checks.

## Known unverified behavior

All Godot implementation, rendered input gameplay, controller hardware, Windows export/runtime, human fun/readability, and performance remain unverified until separately executed and recorded. No claim is made from this planning work alone.

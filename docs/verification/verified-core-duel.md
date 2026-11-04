# Verification record — verified core duel

**Base SHA:** `6365c1eb955b1e9053df73db73f81488759b6711`  
**Branch:** `feat/verified-core-duel`  
**Candidate SHA:** working tree (replace at handoff)  
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

Fixed seed set and held-out scenarios will be recorded with exact outcomes, including all failures. Finite samples will not be described as proof for all floating-point inputs.

- Result: **NOT RUN — implementation pending**.

## Real application and visual checks

An isolated Xvfb display and actual input events will be used if the rendered engine launches. A screenshot alone will support only visual observations.

- Result: **NOT RUN — implementation pending**.

## Review and known gaps

- T-Stack files were read from the separate verification branch; they were not discovered or invoked as installed Cline skills.
- No three-provider council, Sol reviewer, Matt Pocock skill, or poteto skill is available in the inspected cloud paths.
- GUI/controller/human playtest, Windows export and smoke test, performance, and long-session balance have no evidence yet.
- No reviewer findings at this stage.

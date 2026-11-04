# Verification protocol — Last Return

**Status:** design-time verification obligations. These are proposed checks, not passed checks. The game project may not yet exist.

Read `.cline/skills/last-return-verification/SKILL.md`, `docs/SKILL_BOOTSTRAP.md`, the empirical runbook and the relevant authored GDD behavior. Prefer the real app path, focused behavioral tests, and one bounded improvement at a time.

## 1. Claims and evidence levels

| Claim | Minimum useful evidence | What it does **not** establish |
| --- | --- | --- |
| Project loads | Pinned Godot executable, headless import and parser output | Visual/gameplay functionality |
| Projectile returns | Executed physics tests over documented speeds/time steps plus real match footage or manual replay | All floating-point possibilities |
| Score awarded exactly once | Repeated-goal regression test; state-machine invariant; recorded runtime mapping | An untested Godot implementation is refined by the model |
| Pause/retry works | Public game actions and state observation, fresh/reloaded run, representative boundary states | Every untested transition |
| AI is fair | No-teleport/no-future-input architecture tests, speed/acceleration assertions, live behavior | AI is enjoyable or balanced |
| Gameplay is readable | Fixed-setting dynamic capture and user playtest | Accessibility for every player |
| Formal property | Explicit model + actual checker output + assumptions/bounds | Correctness outside the model or scope |
| Release-ready | All relevant evidence at exact candidate SHA and owner Windows smoke test | Permission to merge |

## 2. Required state-machine specification

For the first duel, model the finite state machine before adding complexity. Suggested abstract variables:

- `phase`: `READY | LIVE | GOAL_FREEZE | FINISHED`
- `paused`: boolean
- `player_score`, `rival_score`: integers from 0 to win target (initial target = 5)
- `last_scorer`: none/player/rival
- `serve_owner`: player/rival, if needed by the actual design

Possible actions: `start`, `goal(player)`, `goal(rival)`, `freeze_finished`, `serve`, `pause`, `resume`, `retry`. Only define transitions that the game actually supports. Consider `quit` or `scene_change` when persistence is implemented.

Suggested invariants to **check**, not assume:

1. `0 <= score <= target` and no simultaneous winners.
2. A `goal` event can add exactly one point only when `phase=LIVE` and `paused=false`. After scoring, phase immediately changes away from `LIVE` until an explicit legal restart.
3. `paused=true` blocks game-time, AI, projectile movement and scoring; menu input can still resume.
4. `FINISHED` is terminal for gameplay except explicit new-match/retry action.
5. `retry` clears score, round state, active projectiles, timers and relevant AI state according to the committed spec.
6. `start`, `serve`, and `resume` cannot bypass invalid preconditions.
7. Only one opponent may be the scoring beneficiary of a single crossing; simultaneous or duplicated collision signals have deterministic arbitration.

A **liveness** example (under fairness assumptions): an authorized `serve` from `GOAL_FREEZE` eventually returns the game to `LIVE`. Clearly state whether time, input, or AI fairness assumptions are needed. Do not present liveness as proved simply because a transition exists.

## 3. Formal checker execution

Implement a minimal standalone bounded-exhaustive model checker (Python stdlib is adequate for the discrete FSM), or choose TLA+/TLC, Alloy, or another tool only when justified by capability and model size. The checker must:

- start from its specified initial state;
- enumerate each permitted action and all reachable states within the stated bound;
- check invariants on each transition and reachable state;
- output the number of explored states and transitions and any counterexample trace;
- exit nonzero on an invariant violation;
- include a seeded intentional mutation/negative test showing the checker can fail; and
- record checker version, exact command, model file SHA, limits/bounds, and complete exit status.

Use counterexamples to repair **the actual implementation or a real modelling mistake**; never weaken the oracle merely for a green result. When the model changes, version it and rerun baseline and candidate.

**Mandatory runtime bridge:** write focused Godot integration tests for every abstract action's relevant state transition, with the same independently determined expected outcomes. If the Godot code differs from the abstract model, resolve it. A correct checker of an unrelated model does not verify gameplay.

Formal proof claims must name the model and assumptions. A finite exhaustive state graph can be complete **for that finite abstraction** while still not proving arbitrary real-time physics.

## 4. Physics tests and adversarial scenarios

- Fixed simulation tick, documented `dt`, collision/goal priority, maximum core velocity, swept detection strategy and rail geometry.
- Repeat identical runs with fixed seeds; report nondeterminism rather than discarding outliers.
- Direct wall impact, oblique glancing impact, wall/paddle near-simultaneous collision, goal-edge graze, collision at max speed, post-goal double signal, pause immediately before hit, retry after a goal, scene reload while paused.
- Check momentum and speed cap as designed; allow explicit energy-changing power-ups only with named exceptions.
- Verify bounded paddle position, no AI teleport, and reaction/response constraints.
- Exercise real engine scene with automated input and real GUI/manual tests when available. Unit tests should not mirror private internal computations as their only oracle.

## 5. Hill climbing and council review

Always prioritize executable checks. For aesthetic or feel judgments, use fixed captures, same game state, same rendering settings, anonymized A/B variant labels, and a stable rubric: projectile visibility, aiming clarity, interaction feedback, visual identity, accessibility/readability. Reviewers are independent/read-only where possible; the agent should not show desired scores. Preserve round scores and dissent, but **a council score cannot override failed mechanics tests**.

Budget default: one implementer; at most 3 improvement rounds for speculative refinements unless an explicit spend/time budget is granted. Stop at a useful verified milestone or hard blocker. Do not silently extend the run or purchase model access.

## 6. PR evidence and owner handoff

For each PR, use a short verification record listing:

- Goal and relevant GDD section
- Starting SHA and candidate SHA
- Expected observed behavior and invariant/property
- Baseline red/failure evidence, when fixing a bug
- Checker model, bound, version, command, state count, counterexample or successful check; or `NOT RUN`
- Actual Godot test commands, output, exit codes and platform
- GUI play and screenshot evidence, or `NOT RUN (no display)`
- Held-out seeds or scenarios
- Review findings and resolution
- Unverified items and an explicit owner's next verification action

Before claiming the PR is ready, recheck evidence against the **latest head SHA**. Never self-merge into `dev` or `prod`.

## 7. Current status

No formal model checker, Godot implementation, GUI test, or Windows export is implied by the presence of this document. Implement the smallest appropriate checks as part of the feature and report actual execution.

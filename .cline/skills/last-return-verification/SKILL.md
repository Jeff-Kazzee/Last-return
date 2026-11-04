---
name: last-return-verification
description: Verify Last Return gameplay changes with frozen empirical checks, real application evidence, explicit state-machine specifications and bounded/exhaustive checking where justified. Use for physics, scoring, retry, pause, boss transitions, AI fairness, gameplay UI, and PR completion.
---

# Last Return verification

This skill coordinates a specific **verification process**, not proof that tests or tools have already run. Read `docs/VERIFICATION_PROTOCOL.md` for the current game-specific cases, and the existing project verification skill and feature map when available. Read `docs/references/agent-runbook.md` and relevant sections of `docs/references/theo-hill-climb-playbook.md`.

## First: discover, specify, reproduce

1. Record branch, SHA, environment, intended user-visible behavior, and behavior to preserve.
2. Inspect the actual repository, test tools, commands and game features. If an existing verification skill exists, use it rather than constructing a competing harness; state if missing.
3. For a bug, find a repeatable failure **on the old code**, not just a red parser or missing dependency.
4. State a hypothesis and expected behavior independently of the implementation. Freeze the input cases and success criteria.
5. Change one coherent behavior at a time. Re-run the same checks. Keep or revert **only your own change** based on evidence; preserve unrelated work.

## Empirical ladder

- **Static checks:** Godot headless import, GDScript syntax, project lint/type tooling if applicable. A missing engine cannot be reported as a passing import.
- **Boundary tests:** score attribution, one-goal-per-crossing, cooldowns, retries, pause, transitions, AI motion limits. Prefer black-box or public method/state behavior. Verify the test actually catches a known defect.
- **Physics/property experiments:** fixed-step deterministic traces with explicit seeds, multiple frames, corner impacts, extreme supported speeds, simultaneous collisions and malformed input. Use adversarial/held-out seeds and record the full outcome, not best runs only.
- **Real application path:** launch a real build (with isolated state), play a rally, score, retry, enter a breach, reflect a hostile shot and open the exit. Capture exact actions and resulting state. Use human GUI testing when cloud lacks display/control.
- **Art/UI evidence:** same resolution, input state, scene, theme and effects across before/after captures. Verify readability during movement, not just on a still image. Visual model review cannot prove gameplay correctness.

## Formal methods: precise and appropriately scoped

For fragile discrete logic (goal ownership, serve / active / goal-freeze / match-over / paused / retry, boss phase transitions, invulnerability/cooldowns), write a **small abstract transition model**:

- Explicit state variables and bounded domains.
- Initial state and allowed transitions, including invalid/repeated inputs.
- Safety invariants, assumptions, and liveness obligations if fairness makes them meaningful.
- An executable bounded checker or suitable model checker, with the exact command, version and bound.
- A refinement mapping explaining how Godot runtime states/events correspond to model states, with integration tests for that mapping.

Examples to investigate (not assume already true):
- A goal crossing can award at most one point until a legal reset/serve.
- Scores are between zero and the target; no negative points or concurrent winners.
- A paused world cannot advance scoring, AI movement, or timers.
- Match-over cannot resume into live play except through an explicit new-match transition.
- Retry begins from a defined clean state.
- A boss cannot reach a later phase without the previous phase's exit condition.

**Do not call unit tests, fuzzing, static analysis, reviewer votes, or a bounded state search an unbounded mathematical proof.** A counterexample from a formal model is useful; an abstract model alone does not establish that real Godot code matches it. If no viable checker exists, mark formal verification *not run*, implement and document a bounded checker if reasonable, and keep empirical tests.

For continuous paddle physics, do not pretend a tiny discrete model exhausts floating-point/time-step behavior. Use analytic collision reasoning plus stress tests across allowed speeds/time steps, including swept collision and tie-breaking. Specify remaining uncertainty.

## Iterate and review

Use the user's hill-climb playbook only when a repeatable objective or fixed rubric is available. For a measurable metric, freeze the evaluator, compare baseline/candidate under the same workload, and report complete scores and variation. For taste, use independent read-only reviewers on identically labelled artifacts; hide desired scores, do not infer behavior from screenshots, and preserve accepted checkpoint. Do not optimize a bad test to reach a flattering target.

T-Stack skills may help: `sol-loop` when real Sol access exists, `council` only with actual different-provider delegates, `file-pr` for a concise PR, `babysit-pr` for checks, and `full-stop` for owner handoff. Never self-merge. Time-box optional exploratory review to three rounds unless owner grants more.

## Evidence record (required for each claim)

Record to `docs/verification/<task-id>.md` or PR:

| Field | Required evidence |
| --- | --- |
| Goal | Observable outcome and preserved behavior |
| Revision | Base SHA, candidate SHA, branch and environment |
| Oracle | Independent expected result and fixture/seed |
| Test | Exact command or GUI steps, exit code and output/artifact |
| Formal scope | Model, stated assumptions, checker version/bounds, result or **not run** |
| Runtime link | Integration checks mapping the model back to Godot |
| Review | Reviewer identity/provider if verified, findings and disposition |
| Unknowns | Not run, blocked, environment limitations and manual owner checks |

Only call a PR **ready for owner review** when the evidence covers its actual head revision and known blockers are prominently disclosed. The owner controls all merges and release promotion.

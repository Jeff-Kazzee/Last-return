# Verified core duel — implementation plan

**Branch:** `feat/verified-core-duel`  
**Baseline:** `6365c1eb955b1e9053df73db73f81488759b6711` (`origin/dev`, documentation only)  
**Engine:** Godot 4.4.1 stable, GDScript, Compatibility renderer  
**Evaluation version:** `core-slice-v1`; keep fixtures and expected behavior stable across candidate comparisons.

## Observable outcome and preserved behavior

A player can launch the offline/web project, win or lose a readable first-to-three return duel against a physically constrained adaptive rival, pause/resume and retry cleanly, then enter one connected breach and return sentry projectiles into two exposed locks to open a reachable exit. Rally acceleration, PERFECT timing, focus BRAKE, pressure-wide goals, and bank pylons add tactical depth. Existing design/governance documents and owner-only merge/release gates remain unchanged.

## Bounded milestones

1. **Lifecycle model and executable oracle.** Specify initialization, ready/live/freeze/finished, pause, scoring, serve, completion, and retry. Exhaust the finite model; require a duplicate-goal mutation to fail. Map every event to public GDScript methods with integration tests.
2. **Playable duel.** Add a 120 Hz fixed-step simulation, swept earliest-contact puck movement, passive and aimed active returns, body rebounds, rails and valid goal openings, player movement/aim/strike/dash, reaction-delayed bounded AI, score/serve/pause/retry, and clear keyboard/mouse/gamepad presentation. Preserve all lifecycle checks after each coherent change.
3. **Connected breach.** Reuse movement, aiming, strike timing, and return physics. A return-owned projectile must break the vulnerable mechanism; an enemy-owned shot must not. Body hits use three-health/invulnerability rules. Target destruction visibly opens the exit and entering it completes the slice. Retry resets room state.
4. **Application evidence and handoff.** Run static import, public-boundary tests, fixed-seed and held-out physics scenarios, and real rendered input-driven gameplay where available. Capture artifacts without treating screenshots as behavioral proof. Perform any genuinely available read-only review, resolve verified findings, rerun the complete gate at the final SHA, and open an unmerged PR into `dev`.

## Independent oracles and failure checks

- A goal adds one point only to the crossing beneficiary and duplicate signals cannot score before a new serve.
- Pause preserves timers, positions, velocities, scores, and AI observation state; retry restores the specified clean state.
- A core traveling up to the supported cap cannot cross a rail, paddle, body, or target without the earliest contact being resolved; goal posts reject edge grazes.
- AI displacement and acceleration stay within configured limits and its target uses delayed observations, not future input.
- A return-owned breach shot opens the mechanism; an unreturned shot does not. The exit cannot complete the room before it opens.
- The intentional formal mutation must exit nonzero with a trace. Physics negative controls must demonstrate that the tests detect removed sweep/return ownership.

## Explicit non-goals

No campaign catalog, saves, bosses, online services, runtime AI/art generation, licensed concept-art import, or release/Windows smoke claim. No merge, auto-merge, branch-setting change, or `prod` promotion.

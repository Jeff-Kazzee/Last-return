# Duel lifecycle formal specification

## Scope and assumptions

The model is a finite abstraction of one local, first-to-five duel. It starts in `READY`, unpaused, at 0–0, with the player serving. There is no win-by-two rule. `goal_player` and `goal_rival` represent an already validated whole-core goal crossing; geometry and continuous time are outside this model. Invalid/repeated public events are rejected as self-transitions rather than hidden.

`clock`, `puck`, and `ai` are binary progress tokens. An unpaused `world_tick` toggles `clock`; only `LIVE` toggles actor tokens. These tokens establish pause/freeze ownership in the transition model, not physical correctness. Automatic Godot timers are represented by explicit `start`, `serve`, and `finish` events. A fair scheduler for those events is assumed; liveness is not claimed.

## States

- `phase`: `READY | LIVE | GOAL_FREEZE | FINISHED`.
- `paused`: boolean, orthogonal to the preserved phase.
- `player_score`, `rival_score`: integers 0 through 5.
- `last_scorer`: `none | player | rival`.
- `serve_owner`: `player | rival`; the side that conceded receives the next serve.
- `clock`, `puck`, `ai`: binary abstract progress tokens.

## Transitions

| Event | Preconditions | Effect |
| --- | --- | --- |
| `start` | unpaused `READY` | Enter `LIVE`. |
| `goal_player` / `goal_rival` | unpaused `LIVE` | Add one to only that side, attribute the goal, give serve to the conceder, enter `GOAL_FREEZE`. |
| `serve` | unpaused `GOAL_FREEZE`, no winner | Clear actor progress tokens and enter `READY`; scores are retained. |
| `finish` | unpaused `GOAL_FREEZE`, one winner | Enter `FINISHED`. |
| `pause` | not paused, not `FINISHED` | Set `paused`; preserve phase and all other state. |
| `resume` | paused | Clear only `paused`. |
| `retry` | any state | Restore the exact initial state, including scores, tokens, attribution, and serve owner. |
| `world_tick` | unpaused, not `FINISHED` | Advance clock; advance puck/AI only in `LIVE`. |

Every other event/state combination is rejected without change. A winning goal must pass through `GOAL_FREEZE` before `FINISHED`; a nonwinning goal must pass through `GOAL_FREEZE` and `serve`/`READY` before another `start` can make the game live.

## Checked safety obligations

1. Scores stay within 0–5 and cannot both equal 5.
2. Only an unpaused `LIVE` goal changes a score, by exactly one and only for the intended side; it immediately enters goal freeze, so a duplicate event is rejected.
3. While paused, only `resume` and `retry` can change state; scoring and all progress tokens otherwise remain fixed.
4. `FINISHED` is terminal except for explicit `retry`.
5. `retry` restores every modeled field.
6. Start, serve, and finish require their stated predecessor states; a winner can exist only in resolution or finished states.
7. Actor progress is forbidden outside unpaused `LIVE`.

## Execution and limits

`python3 formal/check_duel_model.py` explores the complete reachable graph under the finite domains above, with a safety cap of 100,000 states and no depth cutoff. `python3 formal/check_duel_model.py --mutate duplicate-goal` intentionally permits scoring during goal freeze and must produce a counterexample and exit 1. `scripts/verify_formal.sh` requires both the clean pass and the expected negative-control failure.

The checker is exhaustive only for this abstraction. It does not prove the GDScript refinement, real-time scheduling, continuous collision physics, rendering, input, or AI behavior. `tests/test_runner.gd` supplies the runtime mapping tests; deterministic and adversarial projectile experiments are reported separately.

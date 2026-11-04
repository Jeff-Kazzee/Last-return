#!/usr/bin/env python3
"""Bounded-exhaustive safety checker for the discrete duel transition model."""
import argparse
from collections import deque
from dataclasses import asdict
from hashlib import sha256
import json
from pathlib import Path
import sys

from duel_model import ACTIONS, INITIAL_STATE, WIN_TARGET, DuelState, Phase, transition, winner

MAX_STATES = 100_000


def state_obligations(state: DuelState) -> None:
    assert 0 <= state.player_score <= WIN_TARGET, "player score out of bounds"
    assert 0 <= state.rival_score <= WIN_TARGET, "rival score out of bounds"
    assert not (state.player_score == WIN_TARGET and state.rival_score == WIN_TARGET), "two winners"
    if state.phase == Phase.FINISHED:
        assert winner(state) != "none", "finished without a winner"
    if winner(state) != "none":
        assert state.phase in (Phase.GOAL_FREEZE, Phase.FINISHED), "winner skipped resolution"
    assert state.clock in (0, 1) and state.puck in (0, 1) and state.ai in (0, 1), "progress token bound"


def transition_obligations(before: DuelState, action: str, after: DuelState) -> None:
    if action == "retry":
        assert after == INITIAL_STATE, "retry did not reset all modeled state"
        return
    if action.startswith("goal_"):
        side = action.removeprefix("goal_")
        if before.phase == Phase.LIVE and not before.paused:
            expected_player = before.player_score + int(side == "player")
            expected_rival = before.rival_score + int(side == "rival")
            assert after.player_score == expected_player, "intended scorer did not gain exactly one"
            assert after.rival_score == expected_rival, "non-scoring side changed"
            assert after.phase == Phase.GOAL_FREEZE, "goal skipped goal-freeze"
            assert after.last_scorer == side, "goal attribution mismatch"
        else:
            assert after == before, "unpaused LIVE is the only scoring source"
        return
    assert after.player_score == before.player_score and after.rival_score == before.rival_score, "non-goal changed score"
    if before.paused:
        if action == "resume":
            assert after == DuelState(**{**asdict(before), "paused": False}), "resume changed more than pause"
        else:
            assert after == before, "paused world advanced"
        return
    if before.phase == Phase.FINISHED:
        assert after == before, "FINISHED restarted without retry"
    if action == "start" and before.phase == Phase.READY:
        assert after.phase == Phase.LIVE, "legal start did not enter LIVE"
    if action == "serve" and before.phase == Phase.GOAL_FREEZE and winner(before) == "none":
        assert after.phase == Phase.READY, "legal serve did not enter READY"
        assert after.puck == 0 and after.ai == 0, "serve retained old world state"
    if action == "finish" and before.phase == Phase.GOAL_FREEZE and winner(before) != "none":
        assert after.phase == Phase.FINISHED, "winning freeze did not finish"
    if action == "world_tick" and before.phase == Phase.LIVE:
        assert after.clock != before.clock and after.puck != before.puck and after.ai != before.ai, "live world did not advance"
    if action == "world_tick" and before.phase != Phase.LIVE:
        assert after.puck == before.puck and after.ai == before.ai, "frozen/ready world moved actors"


def check(mutation: str = "") -> dict:
    queue = deque([INITIAL_STATE])
    traces = {INITIAL_STATE: ()}
    seen = {INITIAL_STATE}
    transition_count = 0
    while queue:
        before = queue.popleft()
        state_obligations(before)
        for action in ACTIONS:
            transition_count += 1
            try:
                after = transition(before, action, mutation)
                state_obligations(after)
                transition_obligations(before, action, after)
            except AssertionError as error:
                return {
                    "result": "COUNTEREXAMPLE",
                    "mutation": mutation or "none",
                    "obligation": str(error),
                    "trace": list(traces[before]) + [action],
                    "before": {**asdict(before), "phase": before.phase.value},
                    "after": {**asdict(after), "phase": after.phase.value} if "after" in locals() else None,
                    "explored_states": len(seen),
                    "explored_transitions": transition_count,
                }
            if after not in seen:
                if len(seen) >= MAX_STATES:
                    raise RuntimeError(f"state safety cap {MAX_STATES} reached; graph not exhausted")
                seen.add(after)
                traces[after] = traces[before] + (action,)
                queue.append(after)
    return {
        "result": "PASS",
        "mutation": mutation or "none",
        "explored_states": len(seen),
        "explored_transitions": transition_count,
        "actions": len(ACTIONS),
        "state_cap": MAX_STATES,
        "win_target": WIN_TARGET,
        "bounds": "scores 0..5; four phases; pause and three progress tokens are binary; exhaustive queue, no depth cutoff",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mutate", choices=("", "duplicate-goal", "stays-live"), default="")
    args = parser.parse_args()
    model_path = Path(__file__).with_name("duel_model.py")
    report = check(args.mutate)
    report["model_sha256"] = sha256(model_path.read_bytes()).hexdigest()
    print(json.dumps(report, indent=2, sort_keys=True))
    return 1 if report["result"] == "COUNTEREXAMPLE" else 0


if __name__ == "__main__":
    sys.exit(main())

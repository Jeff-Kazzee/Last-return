"""Explicit finite abstraction of Last Return's first-to-five duel lifecycle.

This model deliberately excludes continuous movement and collision geometry. The clock,
puck, and AI fields are two-valued progress tokens used to check transition ownership;
they are not numeric physics models.
"""
from dataclasses import dataclass, replace
from enum import Enum

WIN_TARGET = 5


class Phase(str, Enum):
    READY = "READY"
    LIVE = "LIVE"
    GOAL_FREEZE = "GOAL_FREEZE"
    FINISHED = "FINISHED"


@dataclass(frozen=True)
class DuelState:
    phase: Phase = Phase.READY
    paused: bool = False
    player_score: int = 0
    rival_score: int = 0
    last_scorer: str = "none"
    serve_owner: str = "player"
    clock: int = 0
    puck: int = 0
    ai: int = 0


INITIAL_STATE = DuelState()
ACTIONS = (
    "start",
    "goal_player",
    "goal_rival",
    "serve",
    "finish",
    "pause",
    "resume",
    "retry",
    "world_tick",
)


def winner(state: DuelState) -> str:
    if state.player_score == WIN_TARGET:
        return "player"
    if state.rival_score == WIN_TARGET:
        return "rival"
    return "none"


def transition(state: DuelState, action: str, mutation: str = "") -> DuelState:
    """Apply one public event; rejected events are explicit self-transitions."""
    if action not in ACTIONS:
        raise ValueError(f"unknown action: {action}")
    if action == "retry":
        return INITIAL_STATE
    if action == "pause":
        if not state.paused and state.phase != Phase.FINISHED:
            return replace(state, paused=True)
        return state
    if action == "resume":
        return replace(state, paused=False) if state.paused else state
    if state.paused:
        return state

    if action == "start":
        if state.phase == Phase.READY:
            return replace(state, phase=Phase.LIVE)
        return state

    if action in ("goal_player", "goal_rival"):
        duplicate_allowed = mutation == "duplicate-goal" and state.phase == Phase.GOAL_FREEZE
        if state.phase != Phase.LIVE and not duplicate_allowed:
            return state
        side = action.removeprefix("goal_")
        player_score = state.player_score + int(side == "player")
        rival_score = state.rival_score + int(side == "rival")
        next_phase = Phase.LIVE if mutation == "stays-live" else Phase.GOAL_FREEZE
        return replace(
            state,
            phase=next_phase,
            player_score=player_score,
            rival_score=rival_score,
            last_scorer=side,
            serve_owner="rival" if side == "player" else "player",
        )

    if action == "finish":
        if state.phase == Phase.GOAL_FREEZE and winner(state) != "none":
            return replace(state, phase=Phase.FINISHED)
        return state

    if action == "serve":
        if state.phase == Phase.GOAL_FREEZE and winner(state) == "none":
            return replace(state, phase=Phase.READY, puck=0, ai=0)
        return state

    if action == "world_tick":
        if state.phase in (Phase.READY, Phase.LIVE, Phase.GOAL_FREEZE):
            moving = state.phase == Phase.LIVE
            return replace(
                state,
                clock=1 - state.clock,
                puck=1 - state.puck if moving else state.puck,
                ai=1 - state.ai if moving else state.ai,
            )
        return state

    raise AssertionError(f"unhandled action: {action}")

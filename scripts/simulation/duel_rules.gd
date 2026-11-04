extends RefCounted
## Authoritative discrete duel lifecycle. Geometry lives in DuelSimulation.

const READY := "READY"
const LIVE := "LIVE"
const GOAL_FREEZE := "GOAL_FREEZE"
const FINISHED := "FINISHED"
const WIN_TARGET := 5
const READY_SECONDS := 0.8
const FREEZE_SECONDS := 0.65

var phase := READY
var paused := false
var player_score := 0
var rival_score := 0
var last_scorer := "none"
var serve_owner := "player"
var match_time := 0.0
var ready_remaining := READY_SECONDS
var freeze_remaining := 0.0


func _init() -> void:
	reset()


func reset() -> void:
	phase = READY
	paused = false
	player_score = 0
	rival_score = 0
	last_scorer = "none"
	serve_owner = "player"
	match_time = 0.0
	ready_remaining = READY_SECONDS
	freeze_remaining = 0.0


func retry() -> void:
	reset()


func winner() -> String:
	if player_score == WIN_TARGET:
		return "player"
	if rival_score == WIN_TARGET:
		return "rival"
	return "none"


func start() -> bool:
	if paused or phase != READY:
		return false
	phase = LIVE
	ready_remaining = 0.0
	return true


func goal(side: String) -> bool:
	if paused or phase != LIVE or (side != "player" and side != "rival"):
		return false
	if side == "player":
		player_score += 1
		serve_owner = "rival"
	else:
		rival_score += 1
		serve_owner = "player"
	last_scorer = side
	phase = GOAL_FREEZE
	freeze_remaining = FREEZE_SECONDS
	return true


func serve() -> bool:
	if paused or phase != GOAL_FREEZE or winner() != "none":
		return false
	phase = READY
	ready_remaining = READY_SECONDS
	freeze_remaining = 0.0
	return true


func finish() -> bool:
	if paused or phase != GOAL_FREEZE or winner() == "none":
		return false
	phase = FINISHED
	freeze_remaining = 0.0
	return true


func pause() -> bool:
	if paused or phase == FINISHED:
		return false
	paused = true
	return true


func resume() -> bool:
	if not paused:
		return false
	paused = false
	return true


func advance(delta: float) -> void:
	if paused or delta <= 0.0 or phase == FINISHED:
		return
	if phase == LIVE:
		match_time += delta
		return
	if phase == READY:
		ready_remaining = maxf(0.0, ready_remaining - delta)
		if ready_remaining == 0.0:
			start()
		return
	if phase == GOAL_FREEZE:
		freeze_remaining = maxf(0.0, freeze_remaining - delta)
		if freeze_remaining == 0.0:
			if winner() == "none":
				serve()
			else:
				finish()

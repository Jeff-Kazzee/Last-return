extends RefCounted
## Fixed-step, presentation-independent duel simulation.

const DuelRules = preload("res://scripts/simulation/duel_rules.gd")
const Physics = preload("res://scripts/simulation/return_physics.gd")

const LEFT := 90.0
const RIGHT := 1190.0
const TOP := 110.0
const BOTTOM := 650.0
const GOAL_TOP := 285.0
const GOAL_BOTTOM := 475.0
const PUCK_RADIUS := 10.0
const PADDLE_RADIUS := 26.0
const BODY_RADIUS := 17.0
const POST_RADIUS := 12.0
const PADDLE_OFFSET := 46.0
const SERVE_SPEED := 340.0
const MAX_SPEED := 1050.0
const MIN_FORWARD_RATIO := 0.55
const PLAYER_SPEED := 255.0
const PLAYER_ACCELERATION := 1900.0
const AI_MAX_SPEED := 200.0
const AI_ACCELERATION := 1050.0
const AI_DELAY_TICKS := 18
const PLAYER_MIN_X := 150.0
const PLAYER_MAX_X := 570.0
const RIVAL_MIN_X := 710.0
const RIVAL_MAX_X := 1130.0
const ACTOR_MIN_Y := 150.0
const ACTOR_MAX_Y := 610.0

var rules = DuelRules.new()
var player: Dictionary = {}
var rival: Dictionary = {}
var puck: Dictionary = {}
var initial_seed := 424242
var rng := RandomNumberGenerator.new()
var ai_history: Array[Dictionary] = []
var ai_target := Vector2(1030, 360)
var ai_error := 0.0
var ai_recovery := 0.0
var fault_count := 0
var contact_count := 0
var stall_time := 0.0
var events: Array[String] = []


func _init() -> void:
	reset(initial_seed)


func make_actor(position: Vector2, aim: Vector2) -> Dictionary:
	return {"position": position, "velocity": Vector2.ZERO, "aim": aim,
		"strike_remaining": 0.0, "strike_cooldown": 0.0,
		"dash_remaining": 0.0, "dash_cooldown": 0.0, "recoil": 0.0}


func reset(seed_value: int = 424242) -> void:
	initial_seed = seed_value
	rng.seed = seed_value
	rules.reset()
	fault_count = 0
	contact_count = 0
	stall_time = 0.0
	events.clear()
	_setup_serve()


func retry() -> void:
	reset(initial_seed)


func _setup_serve() -> void:
	player = make_actor(Vector2(250, 360), Vector2.RIGHT)
	rival = make_actor(Vector2(1030, 360), Vector2.LEFT)
	var serving_player: bool = rules.serve_owner == "player"
	var direction := 1.0 if serving_player else -1.0
	var angle: float = rng.randf_range(-0.22, 0.22)
	puck = {"position": Vector2(360 if serving_player else 920, 360),
		"velocity": Vector2(direction, 0).rotated(angle) * SERVE_SPEED,
		"radius": PUCK_RADIUS, "last_returner": "none"}
	ai_history.clear()
	ai_target = Vector2(1030, 360)
	ai_error = rng.randf_range(-95.0, 95.0)
	ai_recovery = 0.0
	stall_time = 0.0


func paddle_center(actor: Dictionary) -> Vector2:
	return actor.position + actor.aim * PADDLE_OFFSET


func snapshot() -> Dictionary:
	return {"phase": rules.phase, "paused": rules.paused,
		"player_score": rules.player_score, "rival_score": rules.rival_score,
		"last_scorer": rules.last_scorer, "serve_owner": rules.serve_owner,
		"match_time": rules.match_time, "ready_remaining": rules.ready_remaining,
		"freeze_remaining": rules.freeze_remaining,
		"player": player.duplicate(true), "rival": rival.duplicate(true),
		"puck": puck.duplicate(true), "ai_history": ai_history.duplicate(true),
		"ai_target": ai_target, "ai_error": ai_error, "ai_recovery": ai_recovery,
		"fault_count": fault_count, "contact_count": contact_count,
		"stall_time": stall_time, "rng_state": rng.state}



func step(delta: float, input: Dictionary) -> void:
	if delta <= 0.0 or rules.paused:
		return
	_tick_actorTimers(player, delta)
	_tick_actorTimers(rival, delta)
	ai_recovery = maxf(0.0, ai_recovery - delta)
	if input.get("aim", Vector2.ZERO).length_squared() > 0.01:
		player.aim = input.aim.normalized()
	if input.get("strike", false) and player.strike_cooldown <= 0.0:
		player.strike_remaining = 0.14
		player.strike_cooldown = 0.30
	if input.get("dash", false) and player.dash_cooldown <= 0.0:
		player.dash_remaining = 0.12
		player.dash_cooldown = 0.75
	var player_speed := 610.0 if player.dash_remaining > 0.0 else PLAYER_SPEED
	var player_acceleration := 5200.0 if player.dash_remaining > 0.0 else PLAYER_ACCELERATION
	_move_actor(player, input.get("move", Vector2.ZERO), player_speed, player_acceleration, delta, true)
	var previous_phase: String = rules.phase
	rules.advance(delta)
	if previous_phase == DuelRules.GOAL_FREEZE and rules.phase == DuelRules.READY:
		_setup_serve()
	if rules.phase != DuelRules.LIVE:
		return
	_update_ai(delta)
	_step_puck(delta)
	if rules.phase != DuelRules.LIVE:
		return
	if puck.velocity.length() < 20.0:
		stall_time += delta
	else:
		stall_time = 0.0
	if stall_time > 1.0 or puck.position.y < TOP - 60.0 or puck.position.y > BOTTOM + 60.0:
		_recover_fault()


func _tick_actorTimers(actor: Dictionary, delta: float) -> void:
	actor.strike_remaining = maxf(0.0, actor.strike_remaining - delta)
	actor.strike_cooldown = maxf(0.0, actor.strike_cooldown - delta)
	actor.dash_remaining = maxf(0.0, actor.dash_remaining - delta)
	actor.dash_cooldown = maxf(0.0, actor.dash_cooldown - delta)
	actor.recoil = maxf(0.0, actor.recoil - delta)


func _move_actor(actor: Dictionary, direction: Vector2, speed: float, acceleration: float, delta: float, is_player: bool) -> void:
	var desired := direction.limit_length(1.0) * speed
	actor.velocity = actor.velocity.move_toward(desired, acceleration * delta)
	actor.position += actor.velocity * delta
	actor.position.x = clampf(actor.position.x, PLAYER_MIN_X if is_player else RIVAL_MIN_X, PLAYER_MAX_X if is_player else RIVAL_MAX_X)
	actor.position.y = clampf(actor.position.y, ACTOR_MIN_Y, ACTOR_MAX_Y)


func _update_ai(delta: float) -> void:
	ai_history.append({"position": puck.position, "velocity": puck.velocity})
	if ai_history.size() > AI_DELAY_TICKS + 2:
		ai_history.pop_front()
	if ai_history.size() >= AI_DELAY_TICKS:
		var observed: Dictionary = ai_history[ai_history.size() - AI_DELAY_TICKS]
		ai_target.y = 360.0
		if observed.velocity.x > 20.0:
			var time: float = (rival.position.x - PADDLE_OFFSET - observed.position.x) / observed.velocity.x
			if time > 0.0 and time < 5.0:
				ai_target.y = Physics.fold_rail_value(observed.position.y + observed.velocity.y * time, TOP + PADDLE_RADIUS, BOTTOM - PADDLE_RADIUS) + ai_error
		ai_target.y = clampf(ai_target.y, ACTOR_MIN_Y, ACTOR_MAX_Y)
		var paddle: Vector2 = paddle_center(rival)
		if observed.position.distance_to(paddle) < 105.0 and rival.strike_cooldown <= 0.0:
			rival.strike_remaining = 0.14
			rival.strike_cooldown = 0.36
	var desired := Vector2.ZERO
	if ai_recovery <= 0.0:
		desired = (ai_target - rival.position).limit_length(1.0)
		if rival.position.distance_to(ai_target) < 8.0:
			desired = Vector2.ZERO
	_move_actor(rival, desired, AI_MAX_SPEED, AI_ACCELERATION, delta, false)


func _forward_return(actor: Dictionary, side: String) -> void:
	var speed: float = puck.velocity.length()
	if speed <= Physics.EPSILON:
		return
	var forward := 1.0 if side == "player" else -1.0
	if signf(puck.velocity.x) == forward and absf(puck.velocity.x) >= speed * MIN_FORWARD_RATIO:
		return
	var vertical_sign := signf(puck.velocity.y)
	if vertical_sign == 0.0:
		vertical_sign = signf(actor.aim.y)
	if vertical_sign == 0.0:
		vertical_sign = 1.0
	var horizontal := forward * maxf(absf(puck.velocity.x), speed * MIN_FORWARD_RATIO)
	var vertical := vertical_sign * sqrt(maxf(0.0, speed * speed - horizontal * horizontal))
	puck.velocity = Vector2(horizontal, vertical)


func _recover_fault() -> void:
	fault_count += 1
	rules.phase = DuelRules.READY
	rules.ready_remaining = DuelRules.READY_SECONDS
	rules.freeze_remaining = 0.0
	events.append("fault_serve")
	_setup_serve()


func _step_puck(delta: float) -> void:
	puck.velocity = puck.velocity.limit_length(MAX_SPEED)
	var remaining := delta
	for iteration in range(8):
		if remaining <= Physics.EPSILON or rules.phase != DuelRules.LIVE:
			break
		var start: Vector2 = puck.position
		var motion: Vector2 = puck.velocity * remaining
		var contact := _earliest_contact(start, motion)
		if contact.is_empty():
			puck.position = start + motion
			remaining = 0.0
			break
		var time: float = contact.time
		var contact_position := start + motion * time
		if contact.kind == "goal":
			puck.position = contact_position
			if rules.goal(contact.side):
				events.append("goal_" + contact.side)
			puck.velocity = Vector2.ZERO
			return
		var normal: Vector2 = contact.get("normal", Vector2.ZERO)
		if contact.has("center"):
			normal = (contact_position - contact.center).normalized()
		if normal.length_squared() < 0.5:
			normal = -puck.velocity.normalized()
		puck.position = contact_position + normal * 0.06
		remaining *= 1.0 - time
		match contact.kind:
			"rail", "post":
				puck.velocity = Physics.reflected(puck.velocity, normal, puck.velocity.length())
				events.append("rail")
			"paddle":
				var actor: Dictionary = player if contact.side == "player" else rival
				var active: bool = actor.strike_remaining > 0.0
				var speed: float = puck.velocity.length()
				if active:
					speed = minf(MAX_SPEED, speed * 1.10 + 35.0)
					var aim: Vector2 = actor.aim
					if contact.side == "rival":
						aim = (Vector2(LEFT, 360.0 + ai_error * 2.0) - contact.center).normalized()
					puck.velocity = Physics.aimed_return(puck.velocity, normal, aim, speed, 1.05)
					events.append("strike_" + contact.side)
				else:
					puck.velocity = Physics.reflected(puck.velocity, normal, speed)
					events.append("return_" + contact.side)
				_forward_return(actor, contact.side)
				puck.last_returner = contact.side
				actor.strike_remaining = 0.0
				actor.strike_cooldown = maxf(actor.strike_cooldown, 0.20)
				if contact.side == "rival":
					ai_recovery = 0.28
			"body":
				puck.velocity = Physics.reflected(puck.velocity, normal, 180.0)
				puck.last_returner = "none"
				var actor: Dictionary = player if contact.side == "player" else rival
				actor.recoil = 0.16
				events.append("body_" + contact.side)
		contact_count += 1


func _consider(best: Dictionary, candidate: Dictionary) -> Dictionary:
	if candidate.time < 0.0:
		return best
	if best.is_empty() or candidate.time < best.time - Physics.EPSILON:
		return candidate
	if absf(candidate.time - best.time) <= Physics.EPSILON and candidate.priority > best.priority:
		return candidate
	return best


func _circle_candidate(start: Vector2, motion: Vector2, center: Vector2, radius: float, kind: String, side: String, priority: int) -> Dictionary:
	return {"time": Physics.sweep_circle(start, motion, center, radius), "kind": kind,
		"side": side, "priority": priority, "center": center}


func _earliest_contact(start: Vector2, motion: Vector2) -> Dictionary:
	var best: Dictionary = {}
	if motion.y < 0.0:
		best = _consider(best, {"time": Physics.plane_time(start.y, motion.y, TOP + PUCK_RADIUS),
			"kind": "rail", "priority": 1, "normal": Vector2.DOWN})
	elif motion.y > 0.0:
		best = _consider(best, {"time": Physics.plane_time(start.y, motion.y, BOTTOM - PUCK_RADIUS),
			"kind": "rail", "priority": 1, "normal": Vector2.UP})
	if motion.x < 0.0:
		var wall_time := Physics.plane_time(start.x, motion.x, LEFT + PUCK_RADIUS)
		if wall_time >= 0.0:
			var y: float = start.y + motion.y * wall_time
			if y < GOAL_TOP or y > GOAL_BOTTOM:
				best = _consider(best, {"time": wall_time, "kind": "rail", "priority": 1, "normal": Vector2.RIGHT})
		var goal_time := Physics.plane_time(start.x, motion.x, LEFT - PUCK_RADIUS)
		if goal_time >= 0.0:
			var y: float = start.y + motion.y * goal_time
			if y >= GOAL_TOP + PUCK_RADIUS and y <= GOAL_BOTTOM - PUCK_RADIUS:
				best = _consider(best, {"time": goal_time, "kind": "goal", "side": "rival", "priority": 2})
	elif motion.x > 0.0:
		var wall_time := Physics.plane_time(start.x, motion.x, RIGHT - PUCK_RADIUS)
		if wall_time >= 0.0:
			var y: float = start.y + motion.y * wall_time
			if y < GOAL_TOP or y > GOAL_BOTTOM:
				best = _consider(best, {"time": wall_time, "kind": "rail", "priority": 1, "normal": Vector2.LEFT})
		var goal_time := Physics.plane_time(start.x, motion.x, RIGHT + PUCK_RADIUS)
		if goal_time >= 0.0:
			var y: float = start.y + motion.y * goal_time
			if y >= GOAL_TOP + PUCK_RADIUS and y <= GOAL_BOTTOM - PUCK_RADIUS:
				best = _consider(best, {"time": goal_time, "kind": "goal", "side": "player", "priority": 2})

	for x in [LEFT, RIGHT]:
		for y in [GOAL_TOP, GOAL_BOTTOM]:
			best = _consider(best, _circle_candidate(start, motion, Vector2(x, y), PUCK_RADIUS + POST_RADIUS, "post", "none", 1))
	for side in ["player", "rival"]:
		var actor: Dictionary = player if side == "player" else rival
		best = _consider(best, _circle_candidate(start, motion, paddle_center(actor), PUCK_RADIUS + PADDLE_RADIUS, "paddle", side, 3))
		best = _consider(best, _circle_candidate(start, motion, actor.position, PUCK_RADIUS + BODY_RADIUS, "body", side, 1))
	return best


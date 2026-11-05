extends RefCounted
## Fixed-step, presentation-independent duel simulation.

const DuelRules = preload("res://scripts/simulation/duel_rules.gd")
const Physics = preload("res://scripts/simulation/return_physics.gd")

const LEFT := 90.0
const RIGHT := 1190.0
const TOP := 110.0
const BOTTOM := 650.0
const GOAL_TOP := 250.0
const GOAL_BOTTOM := 510.0
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
const AI_MAX_SPEED := 240.0
const AI_ACCELERATION := 1250.0
const AI_DELAY_TICKS := 10
const PYLON_RADIUS := 18.0
const BRAKE_COST := 65.0
const PERFECT_WINDOW := 0.105
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
var ai_target := Vector2(1040, 360)
var ai_error := 0.0
var ai_recovery := 0.0
var ai_speed_cap := AI_MAX_SPEED
var ai_reaction_ticks := AI_DELAY_TICKS
var ai_aim_offset := 0.0
var ai_tier := 0
var fault_count := 0
var contact_count := 0
var stall_time := 0.0
var rally_hits := 0
var brake_energy := 0.0
var brake_remaining := 0.0
var brake_cooldown := 0.0
var last_return_grade := "none"
var return_flash := 0.0
var pylons: Array[Vector2] = [Vector2(640, 250), Vector2(640, 510)]
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
	rally_hits = 0
	brake_energy = 0.0
	brake_remaining = 0.0
	brake_cooldown = 0.0
	last_return_grade = "none"
	return_flash = 0.0
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
	ai_target = Vector2(1040, 360)
	ai_tier = mini(2, rules.player_score)
	ai_speed_cap = minf(PLAYER_SPEED - 2.0, AI_MAX_SPEED + ai_tier * 8.0)
	ai_reaction_ticks = maxi(6, AI_DELAY_TICKS - ai_tier * 2)
	var error_range := 55.0 - ai_tier * 12.0
	ai_error = rng.randf_range(-error_range, error_range)
	ai_aim_offset = rng.randf_range(-150.0 - ai_tier * 25.0, 150.0 + ai_tier * 25.0)
	ai_recovery = 0.0
	stall_time = 0.0
	rally_hits = 0
	brake_remaining = 0.0
	last_return_grade = "none"
	return_flash = 0.0


func paddle_center(actor: Dictionary) -> Vector2:
	return actor.position + actor.aim * PADDLE_OFFSET


func goal_bounds() -> Vector2:
	var expansion := clampf(float(maxi(0, rally_hits - 6)) * 10.0, 0.0, 100.0)
	return Vector2(GOAL_TOP - expansion, GOAL_BOTTOM + expansion)


func snapshot() -> Dictionary:
	return {"phase": rules.phase, "paused": rules.paused,
		"player_score": rules.player_score, "rival_score": rules.rival_score,
		"last_scorer": rules.last_scorer, "serve_owner": rules.serve_owner,
		"match_time": rules.match_time, "ready_remaining": rules.ready_remaining,
		"freeze_remaining": rules.freeze_remaining,
		"player": player.duplicate(true), "rival": rival.duplicate(true),
		"puck": puck.duplicate(true), "ai_history": ai_history.duplicate(true),
		"ai_target": ai_target, "ai_error": ai_error, "ai_recovery": ai_recovery,
		"ai_speed_cap": ai_speed_cap, "ai_reaction_ticks": ai_reaction_ticks,
		"ai_aim_offset": ai_aim_offset, "ai_tier": ai_tier,
		"fault_count": fault_count, "contact_count": contact_count,
		"stall_time": stall_time, "rally_hits": rally_hits,
		"brake_energy": brake_energy, "brake_remaining": brake_remaining,
		"brake_cooldown": brake_cooldown, "last_return_grade": last_return_grade,
		"return_flash": return_flash, "pylons": pylons.duplicate(),
		"rng_state": rng.state}



func step(delta: float, input: Dictionary) -> void:
	if delta <= 0.0 or rules.paused:
		return
	_tick_actorTimers(player, delta)
	_tick_actorTimers(rival, delta)
	ai_recovery = maxf(0.0, ai_recovery - delta)
	brake_remaining = maxf(0.0, brake_remaining - delta)
	brake_cooldown = maxf(0.0, brake_cooldown - delta)
	return_flash = maxf(0.0, return_flash - delta)
	if input.get("technique", false) and brake_energy >= BRAKE_COST and brake_cooldown <= 0.0:
		brake_energy -= BRAKE_COST
		brake_remaining = 0.52
		brake_cooldown = 1.1
		events.append("brake")
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
	_step_puck(delta * (0.30 if brake_remaining > 0.0 else 1.0))
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
	if ai_history.size() > ai_reaction_ticks + 2:
		ai_history.pop_front()
	if ai_history.size() >= ai_reaction_ticks:
		var observed: Dictionary = ai_history[ai_history.size() - ai_reaction_ticks]
		ai_target.y = 360.0
		if observed.velocity.x > 20.0:
			var time: float = (rival.position.x - PADDLE_OFFSET - observed.position.x) / observed.velocity.x
			if time > 0.0 and time < 5.0:
				ai_target.y = Physics.fold_rail_value(observed.position.y + observed.velocity.y * time, TOP + PADDLE_RADIUS, BOTTOM - PADDLE_RADIUS) + ai_error
		ai_target.y = clampf(ai_target.y, ACTOR_MIN_Y, ACTOR_MAX_Y)
		var paddle: Vector2 = paddle_center(rival)
		if observed.position.distance_to(paddle) < 140.0 and rival.strike_cooldown <= 0.0:
			rival.strike_remaining = 0.14
			rival.strike_cooldown = 0.36
	var desired := Vector2.ZERO
	if ai_recovery <= 0.0:
		desired = (ai_target - rival.position).limit_length(1.0)
		if rival.position.distance_to(ai_target) < 8.0:
			desired = Vector2.ZERO
	_move_actor(rival, desired, ai_speed_cap, AI_ACCELERATION, delta, false)


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
			"rail", "post", "pylon":
				puck.velocity = Physics.reflected(puck.velocity, normal, puck.velocity.length())
				events.append("pylon" if contact.kind == "pylon" else "rail")
			"paddle":
				var actor: Dictionary = player if contact.side == "player" else rival
				var active: bool = actor.strike_remaining > 0.0
				var perfect: bool = active and actor.strike_remaining >= PERFECT_WINDOW
				rally_hits += 1
				var surge: float = 1.0 + minf(float(rally_hits) * 0.045, 0.36)
				var speed: float = minf(MAX_SPEED, maxf(puck.velocity.length(), SERVE_SPEED) * surge)
				if active:
					speed = minf(MAX_SPEED, speed * (1.18 if perfect else 1.08) + (45.0 if perfect else 25.0))
					var aim: Vector2 = actor.aim
					if contact.side == "rival":
						aim = (Vector2(LEFT, 360.0 + ai_aim_offset) - contact.center).normalized()
					puck.velocity = Physics.aimed_return(puck.velocity, normal, aim, speed, 1.15 if perfect else 1.05)
					events.append(("perfect_" if perfect else "strike_") + contact.side)
					if contact.side == "player":
						last_return_grade = "perfect" if perfect else "active"
						brake_energy = minf(100.0, brake_energy + (24.0 if perfect else 14.0))
				else:
					puck.velocity = Physics.reflected(puck.velocity, normal, speed)
					events.append("return_" + contact.side)
					if contact.side == "player":
						last_return_grade = "passive"
						brake_energy = minf(100.0, brake_energy + 6.0)
				_forward_return(actor, contact.side)
				if contact.side == "player":
					return_flash = 0.55
				puck.last_returner = contact.side
				actor.strike_remaining = 0.0
				actor.strike_cooldown = maxf(actor.strike_cooldown, 0.20)
				if contact.side == "rival":
					ai_recovery = 0.20
			"body":
				puck.velocity = Physics.reflected(puck.velocity, normal, 180.0)
				puck.last_returner = "none"
				rally_hits = 0
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
	var bounds := goal_bounds()
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
			if y < bounds.x or y > bounds.y:
				best = _consider(best, {"time": wall_time, "kind": "rail", "priority": 1, "normal": Vector2.RIGHT})
		var goal_time := Physics.plane_time(start.x, motion.x, LEFT - PUCK_RADIUS)
		if goal_time >= 0.0:
			var y: float = start.y + motion.y * goal_time
			if y >= bounds.x + PUCK_RADIUS and y <= bounds.y - PUCK_RADIUS:
				best = _consider(best, {"time": goal_time, "kind": "goal", "side": "rival", "priority": 2})
	elif motion.x > 0.0:
		var wall_time := Physics.plane_time(start.x, motion.x, RIGHT - PUCK_RADIUS)
		if wall_time >= 0.0:
			var y: float = start.y + motion.y * wall_time
			if y < bounds.x or y > bounds.y:
				best = _consider(best, {"time": wall_time, "kind": "rail", "priority": 1, "normal": Vector2.LEFT})
		var goal_time := Physics.plane_time(start.x, motion.x, RIGHT + PUCK_RADIUS)
		if goal_time >= 0.0:
			var y: float = start.y + motion.y * goal_time
			if y >= bounds.x + PUCK_RADIUS and y <= bounds.y - PUCK_RADIUS:
				best = _consider(best, {"time": goal_time, "kind": "goal", "side": "player", "priority": 2})

	for x in [LEFT, RIGHT]:
		for y in [bounds.x, bounds.y]:
			best = _consider(best, _circle_candidate(start, motion, Vector2(x, y), PUCK_RADIUS + POST_RADIUS, "post", "none", 1))
	for pylon in pylons:
		best = _consider(best, _circle_candidate(start, motion, pylon, PUCK_RADIUS + PYLON_RADIUS, "pylon", "none", 1))
	for side in ["player", "rival"]:
		var actor: Dictionary = player if side == "player" else rival
		best = _consider(best, _circle_candidate(start, motion, paddle_center(actor), PUCK_RADIUS + PADDLE_RADIUS, "paddle", side, 3))
		best = _consider(best, _circle_candidate(start, motion, actor.position, PUCK_RADIUS + BODY_RADIUS, "body", side, 1))
	return best


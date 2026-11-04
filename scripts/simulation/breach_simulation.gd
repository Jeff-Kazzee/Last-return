extends RefCounted
## Short return-combat room. The armored mechanism accepts only a returned core.

const Physics = preload("res://scripts/simulation/return_physics.gd")
const LEFT := 90.0
const RIGHT := 1190.0
const TOP := 110.0
const BOTTOM := 650.0
const PUCK_RADIUS := 10.0
const PADDLE_RADIUS := 26.0
const BODY_RADIUS := 17.0
const TARGET_RADIUS := 42.0
const PADDLE_OFFSET := 46.0
const MAX_SPEED := 900.0

var player: Dictionary = {}
var puck: Dictionary = {}
var bolts: Array[Dictionary] = []
var sentry_position := Vector2(950, 250)
var anchor_positions: Array[Vector2] = [Vector2(1060, 300), Vector2(1000, 530)]
var target_position := Vector2(1060, 300)
var anchor_index := 0
var anchors_remaining := 2
var exit_center := Vector2(1130, 565)
var health := 3
var target_alive := true
var exit_open := false
var completed := false
var failed := false
var paused := false
var invulnerability := 0.0
var sidearm_cooldown := 0.0
var respawn_remaining := 0.0
var sentry_stun := 0.0
var elapsed := 0.0
var events: Array[String] = []


func _init() -> void:
	reset()


func make_actor() -> Dictionary:
	return {"position": Vector2(240, 500), "velocity": Vector2.ZERO,
		"aim": Vector2.RIGHT, "strike_remaining": 0.0, "strike_cooldown": 0.0,
		"dash_remaining": 0.0, "dash_cooldown": 0.0, "recoil": 0.0}


func reset() -> void:
	player = make_actor()
	bolts.clear()
	health = 3
	target_alive = true
	anchor_index = 0
	anchors_remaining = anchor_positions.size()
	target_position = anchor_positions[0]
	exit_open = false
	completed = false
	failed = false
	paused = false
	invulnerability = 0.0
	sidearm_cooldown = 0.0
	respawn_remaining = 0.0
	sentry_stun = 0.0
	elapsed = 0.0
	events.clear()
	_spawn_shot()


func retry() -> void:
	reset()


func _spawn_shot() -> void:
	var direction: Vector2 = (player.position - sentry_position).normalized()
	puck = {"position": sentry_position + direction * 44.0,
		"velocity": direction * 320.0, "last_returner": "enemy",
		"active": true, "age": 0.0}
	events.append("sentry_shot")


func paddle_center(actor: Dictionary) -> Vector2:
	return actor.position + actor.aim * PADDLE_OFFSET


func snapshot() -> Dictionary:
	return {"player": player.duplicate(true), "puck": puck.duplicate(true),
		"bolts": bolts.duplicate(true), "health": health, "target_alive": target_alive,
		"target_position": target_position, "anchor_index": anchor_index,
		"anchors_remaining": anchors_remaining,
		"exit_open": exit_open, "completed": completed, "failed": failed, "paused": paused,
		"invulnerability": invulnerability, "sidearm_cooldown": sidearm_cooldown,
		"respawn_remaining": respawn_remaining, "sentry_stun": sentry_stun, "elapsed": elapsed}


func step(delta: float, input: Dictionary) -> void:
	if delta <= 0.0 or paused or completed or failed:
		return
	elapsed += delta
	invulnerability = maxf(0.0, invulnerability - delta)
	sidearm_cooldown = maxf(0.0, sidearm_cooldown - delta)
	sentry_stun = maxf(0.0, sentry_stun - delta)
	for key in ["strike_remaining", "strike_cooldown", "dash_remaining", "dash_cooldown", "recoil"]:
		player[key] = maxf(0.0, player[key] - delta)
	if input.get("aim", Vector2.ZERO).length_squared() > 0.01:
		player.aim = input.aim.normalized()
	if input.get("strike", false) and player.strike_cooldown <= 0.0:
		player.strike_remaining = 0.14
		player.strike_cooldown = 0.30
	if input.get("dash", false) and player.dash_cooldown <= 0.0:
		player.dash_remaining = 0.12
		player.dash_cooldown = 0.75
	if input.get("fire", false) and sidearm_cooldown <= 0.0:
		sidearm_cooldown = 0.25
		bolts.append({"position": player.position + player.aim * 32.0,
			"velocity": player.aim * 700.0, "life": 0.9})
		events.append("sidearm")
	var speed := 610.0 if player.dash_remaining > 0.0 else 255.0
	var acceleration := 5200.0 if player.dash_remaining > 0.0 else 1900.0
	var direction: Vector2 = input.get("move", Vector2.ZERO).limit_length(1.0)
	player.velocity = player.velocity.move_toward(direction * speed, acceleration * delta)
	player.position += player.velocity * delta
	player.position.x = clampf(player.position.x, 130.0, 1150.0)
	player.position.y = clampf(player.position.y, 150.0, 610.0)
	_step_bolts(delta)
	if puck.active:
		puck.age += delta
		_step_puck(delta)
		if puck.active and puck.age > 6.0:
			_spawn_shot()
	elif target_alive:
		respawn_remaining = maxf(0.0, respawn_remaining - delta)
		if respawn_remaining == 0.0 and sentry_stun <= 0.0:
			_spawn_shot()
	if exit_open and player.position.distance_to(exit_center) <= 42.0:
		completed = true
		events.append("breach_complete")


func _step_bolts(delta: float) -> void:
	var survivors: Array[Dictionary] = []
	for bolt in bolts:
		bolt.position += bolt.velocity * delta
		bolt.life -= delta
		if bolt.position.distance_to(sentry_position) <= 28.0:
			sentry_stun = 0.7
			events.append("sentry_stun")
		elif bolt.life > 0.0:
			survivors.append(bolt)
	bolts = survivors


func _consider(best: Dictionary, candidate: Dictionary) -> Dictionary:
	if candidate.time < 0.0:
		return best
	if best.is_empty() or candidate.time < best.time - Physics.EPSILON:
		return candidate
	if absf(candidate.time - best.time) <= Physics.EPSILON and candidate.priority > best.priority:
		return candidate
	return best


func _circle(start: Vector2, motion: Vector2, center: Vector2, radius: float, kind: String, priority: int) -> Dictionary:
	return {"time": Physics.sweep_circle(start, motion, center, radius),
		"kind": kind, "priority": priority, "center": center}


func _earliest_contact(start: Vector2, motion: Vector2) -> Dictionary:
	var best: Dictionary = {}
	if motion.y < 0.0:
		best = _consider(best, {"time": Physics.plane_time(start.y, motion.y, TOP + PUCK_RADIUS), "kind": "rail", "priority": 1, "normal": Vector2.DOWN})
	elif motion.y > 0.0:
		best = _consider(best, {"time": Physics.plane_time(start.y, motion.y, BOTTOM - PUCK_RADIUS), "kind": "rail", "priority": 1, "normal": Vector2.UP})
	if motion.x < 0.0:
		best = _consider(best, {"time": Physics.plane_time(start.x, motion.x, LEFT + PUCK_RADIUS), "kind": "rail", "priority": 1, "normal": Vector2.RIGHT})
	elif motion.x > 0.0:
		best = _consider(best, {"time": Physics.plane_time(start.x, motion.x, RIGHT - PUCK_RADIUS), "kind": "rail", "priority": 1, "normal": Vector2.LEFT})
	best = _consider(best, _circle(start, motion, paddle_center(player), PUCK_RADIUS + PADDLE_RADIUS, "paddle", 3))
	best = _consider(best, _circle(start, motion, player.position, PUCK_RADIUS + BODY_RADIUS, "body", 1))
	if target_alive:
		best = _consider(best, _circle(start, motion, target_position, PUCK_RADIUS + TARGET_RADIUS, "target", 2))
	return best


func _step_puck(delta: float) -> void:
	puck.velocity = puck.velocity.limit_length(MAX_SPEED)
	var remaining := delta
	for iteration in range(8):
		if remaining <= Physics.EPSILON or not puck.active:
			break
		var start: Vector2 = puck.position
		var motion: Vector2 = puck.velocity * remaining
		var contact := _earliest_contact(start, motion)
		if contact.is_empty():
			puck.position = start + motion
			break
		var contact_position: Vector2 = start + motion * contact.time
		var normal: Vector2 = contact.get("normal", Vector2.ZERO)
		if contact.has("center"):
			normal = (contact_position - contact.center).normalized()
		if normal.length_squared() < 0.5:
			normal = -puck.velocity.normalized()
		puck.position = contact_position + normal * 0.06
		remaining *= 1.0 - contact.time
		match contact.kind:
			"rail":
				puck.velocity = Physics.reflected(puck.velocity, normal, puck.velocity.length())
			"paddle":
				var speed: float = puck.velocity.length()
				if player.strike_remaining > 0.0:
					speed = minf(MAX_SPEED, speed * 1.10 + 35.0)
					puck.velocity = Physics.aimed_return(puck.velocity, normal, player.aim, speed, 1.05)
					events.append("strike_player")
				else:
					puck.velocity = Physics.reflected(puck.velocity, normal, speed)
					events.append("return_player")
				puck.last_returner = "player"
				player.strike_remaining = 0.0
				player.strike_cooldown = maxf(player.strike_cooldown, 0.20)
			"body":
				if invulnerability <= 0.0:
					health -= 1
					invulnerability = 0.9
					player.recoil = 0.16
					events.append("body_damage")
					if health <= 0:
						failed = true
				puck.active = false
				puck.velocity = Vector2.ZERO
				puck.last_returner = "none"
				respawn_remaining = 0.8
			"target":
				if puck.last_returner == "player":
					anchors_remaining -= 1
					puck.active = false
					puck.velocity = Vector2.ZERO
					if anchors_remaining > 0:
						anchor_index += 1
						target_position = anchor_positions[anchor_index]
						respawn_remaining = 0.55
						events.append("target_damage")
					else:
						target_alive = false
						exit_open = true
						respawn_remaining = 0.0
						events.append("target_break")
				else:
					puck.velocity = Physics.reflected(puck.velocity, normal, puck.velocity.length())
					events.append("armor_reject")


extends RefCounted

const DuelSimulation = preload("res://scripts/simulation/duel_simulation.gd")
const ReturnPhysics = preload("res://scripts/simulation/return_physics.gd")
const DT := 1.0 / 120.0


func run(test: SceneTree) -> void:
	_test_swept_contact_and_negative_control(test)
	_test_rail_and_paddle_adversaries(test)
	_test_active_return_contract(test)
	_test_goal_boundaries(test)
	_test_pause_and_retry_at_impact(test)
	_test_determinism_and_held_out_seeds(test)
	_test_rival_constraints(test)
	_test_stationary_defender(test)
	_test_player_movement_dash_and_body(test)
	_test_rally_pylons_precision_and_brake(test)


func blank_input() -> Dictionary:
	return {"move": Vector2.ZERO, "aim": Vector2.ZERO, "strike": false, "dash": false}


func live_sim(seed_value: int = 12345) -> RefCounted:
	var sim = DuelSimulation.new()
	sim.reset(seed_value)
	sim.rules.start()
	return sim


func set_puck(sim: RefCounted, position: Vector2, velocity: Vector2) -> void:
	sim.puck.position = position
	sim.puck.velocity = velocity


func _test_swept_contact_and_negative_control(test: SceneTree) -> void:
	var hit_time: float = ReturnPhysics.sweep_circle(Vector2(0, 0), Vector2(200, 0), Vector2(100, 0), 10.0)
	test.expect(is_equal_approx(hit_time, 0.45), "swept circle returns analytic earliest hit")
	var naive_end_overlap := Vector2(200, 0).distance_to(Vector2(100, 0)) <= 10.0
	test.expect(not naive_end_overlap and hit_time >= 0.0, "negative control: end-overlap misses fixture that sweep detects")
	var miss: float = ReturnPhysics.sweep_circle(Vector2(0, 30), Vector2(200, 0), Vector2(100, 0), 10.0)
	test.expect(miss < 0.0, "swept circle rejects separated path")
	var departing: float = ReturnPhysics.sweep_circle(Vector2(95, 0), Vector2(-200, 0), Vector2(100, 0), 10.0)
	test.expect(departing < 0.0, "overlapping departure is not a fresh collision")


func _test_rail_and_paddle_adversaries(test: SceneTree) -> void:
	var sim = live_sim()
	set_puck(sim, Vector2(640, 125), Vector2(0, -1050))
	sim.step(0.1, blank_input())
	test.expect(sim.puck.velocity.y > 0.0, "maximum-speed core cannot tunnel through top rail")
	test.expect(sim.puck.position.y >= sim.TOP + sim.PUCK_RADIUS - 0.01, "rail contact leaves core in valid bounds")
	test.expect(is_equal_approx(sim.puck.velocity.length(), 1050.0), "passive rail preserves capped speed")
	sim = live_sim()
	sim.player.position = Vector2(250, 360)
	sim.player.aim = Vector2.RIGHT
	var paddle: Vector2 = sim.paddle_center(sim.player)
	set_puck(sim, paddle + Vector2(120, 0), Vector2(-1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.puck.last_returner == "player" and sim.puck.velocity.x > 0.0, "maximum-speed core cannot tunnel through player paddle")
	sim = live_sim()
	sim.player.position = Vector2(250, 156)
	sim.player.aim = Vector2.RIGHT
	set_puck(sim, Vector2(376, 200), Vector2(-800, -800))
	sim.step(0.1, blank_input())
	test.expect(sim.puck.last_returner == "player", "exact rail/paddle contact tie favors paddle")
	test.expect(sim.puck.velocity.length() <= sim.MAX_SPEED + 0.001, "tie resolution respects speed cap")
	sim = live_sim()
	sim.player.position = Vector2(250, 360)
	sim.player.aim = Vector2.RIGHT
	set_puck(sim, sim.paddle_center(sim.player) + Vector2(0, -80), Vector2(0, 600))
	sim.step(0.1, blank_input())
	test.expect(sim.puck.last_returner == "player" and sim.puck.velocity.x >= sim.puck.velocity.length() * 0.50, "vertical paddle contact retains majority forward travel")
	test.expect(sim.puck.velocity.length() <= sim.MAX_SPEED + 0.001, "forward-travel correction preserves speed cap")


func _test_active_return_contract(test: SceneTree) -> void:
	var passive = live_sim()
	passive.player.position = Vector2(250, 360)
	passive.player.aim = Vector2.RIGHT
	set_puck(passive, passive.paddle_center(passive.player) + Vector2(80, 0), Vector2(-600, 0))
	passive.step(0.1, blank_input())
	var active = live_sim()
	active.player.position = Vector2(250, 360)
	var aimed := Vector2(1, -0.5).normalized()
	active.player.aim = aimed
	var input := blank_input()
	input.aim = aimed
	input.strike = true
	set_puck(active, active.paddle_center(active.player) + Vector2(80, 0), Vector2(-600, 0))
	active.step(0.1, input)
	test.expect(active.puck.last_returner == "player", "timed active strike still requires real paddle contact")
	test.expect(active.puck.velocity.y < 0.0, "active strike influences return toward aim")
	test.expect(active.puck.velocity.length() > passive.puck.velocity.length(), "active strike adds bounded pace")
	test.expect(active.puck.velocity.length() <= active.MAX_SPEED + 0.001, "active strike cannot exceed cap")
	var no_contact = live_sim()
	no_contact.puck.position = Vector2(640, 200)
	no_contact.puck.velocity = Vector2.ZERO
	no_contact.step(DT, input)
	test.expect(no_contact.puck.last_returner == "none", "strike input without contact is not a return")


func _test_goal_boundaries(test: SceneTree) -> void:
	var sim = live_sim()
	set_puck(sim, Vector2(100, 360), Vector2(-1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rules.rival_score == 1 and sim.rules.player_score == 0, "whole-core left crossing awards rival once")
	test.expect(sim.rules.phase == "GOAL_FREEZE", "legal crossing enters goal freeze")
	set_puck(sim, Vector2(40, 360), Vector2(-1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rules.rival_score == 1, "post-goal repeated crossing cannot score")
	sim = live_sim()
	set_puck(sim, Vector2(1180, 360), Vector2(1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rules.player_score == 1 and sim.rules.rival_score == 0, "whole-core right crossing awards player once")
	sim = live_sim()
	set_puck(sim, Vector2(100, sim.GOAL_TOP + 2), Vector2(-1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rules.player_score == 0 and sim.rules.rival_score == 0, "goal-post graze is not a goal")
	sim = live_sim()
	set_puck(sim, Vector2(100, sim.GOAL_TOP - 30), Vector2(-1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rules.rival_score == 0 and sim.puck.velocity.x > 0.0, "closed side rail rebounds instead of scoring")



func _test_pause_and_retry_at_impact(test: SceneTree) -> void:
	var sim = live_sim(777)
	sim.player.position = Vector2(250, 360)
	sim.player.aim = Vector2.RIGHT
	set_puck(sim, sim.paddle_center(sim.player) + Vector2(45, 0), Vector2(-1050, 0))
	sim.rules.pause()
	var before: Dictionary = sim.snapshot()
	for index in range(20):
		sim.step(DT, blank_input())
	test.expect(sim.snapshot() == before, "pause immediately before impact freezes complete public simulation state")
	sim.rules.resume()
	sim.step(DT, blank_input())
	test.expect(sim.snapshot() != before, "resume allows pending impact to resolve")
	if sim.rules.phase == "LIVE":
		sim.rules.goal("rival")
	sim.retry()
	test.expect(sim.rules.player_score == 0 and sim.rules.rival_score == 0, "retry after impact clears score")
	test.expect(sim.puck.velocity.length() <= sim.SERVE_SPEED and sim.ai_history.is_empty(), "retry resets projectile and AI history")
	test.expect(sim.rules.phase == "READY" and not sim.rules.paused, "retry returns to unpaused protected serve")


func _test_determinism_and_held_out_seeds(test: SceneTree) -> void:
	var first = DuelSimulation.new()
	var second = DuelSimulation.new()
	first.reset(90210)
	second.reset(90210)
	var identical := true
	for index in range(1800):
		first.step(DT, blank_input())
		second.step(DT, blank_input())
		if index % 30 == 0 and first.snapshot() != second.snapshot():
			identical = false
	test.expect(identical, "same seed and inputs produce identical 15-second trace")
	var seeds := [7, 19, 43, 101, 509, 1021, 7919, 65537]
	var all_valid := true
	var capped := true
	for seed_value in seeds:
		var sim = DuelSimulation.new()
		sim.reset(seed_value)
		for index in range(2400):
			sim.step(DT, blank_input())
			if sim.rules.player_score < 0 or sim.rules.rival_score < 0 or sim.rules.player_score > 3 or sim.rules.rival_score > 3:
				all_valid = false
			if sim.puck.velocity.length() > sim.MAX_SPEED + 0.01:
				capped = false
	test.expect(all_valid, "eight held-out seeds keep score and match bounds for 20 seconds each")
	test.expect(capped, "eight held-out seeds never exceed supported core speed")


func _test_rival_constraints(test: SceneTree) -> void:
	var sim = live_sim(2468)
	var displacement_ok := true
	var acceleration_ok := true
	var bounds_ok := true
	for index in range(1200):
		var old_position: Vector2 = sim.rival.position
		var old_velocity: Vector2 = sim.rival.velocity
		sim.step(DT, blank_input())
		if old_position.distance_to(sim.rival.position) > sim.AI_MAX_SPEED * DT + 0.01:
			displacement_ok = false
		if old_velocity.distance_to(sim.rival.velocity) > sim.AI_ACCELERATION * DT + 0.01:
			acceleration_ok = false
		if sim.rival.position.x < sim.RIVAL_MIN_X - 0.01 or sim.rival.position.x > sim.RIVAL_MAX_X + 0.01:
			bounds_ok = false
	test.expect(displacement_ok, "rival never teleports or exceeds per-tick speed bound")
	test.expect(acceleration_ok, "rival obeys acceleration bound")
	test.expect(bounds_ok, "rival remains in legal half")
	sim = live_sim()
	var original_target: Vector2 = sim.ai_target
	set_puck(sim, Vector2(700, 120), Vector2(500, 400))
	for index in range(sim.AI_DELAY_TICKS - 1):
		sim.step(DT, blank_input())
	test.expect(sim.ai_target == original_target, "rival target does not react before observation delay")
	sim.step(DT, blank_input())
	test.expect(sim.ai_target != original_target, "rival reacts after delayed observation becomes available")


func _test_stationary_defender(test: SceneTree) -> void:
	var sim = DuelSimulation.new()
	sim.reset(13579)
	for index in range(14400):
		sim.step(DT, blank_input())
		if sim.rules.phase == "FINISHED":
			break
	test.expect(sim.rules.rival_score > 0, "stationary defender concedes under physical rival pressure")
	test.expect(sim.rules.player_score < 3, "stationary defender cannot win first-to-three indefinitely")


func _test_player_movement_dash_and_body(test: SceneTree) -> void:
	var normal = live_sim()
	var dashed = live_sim()
	var move := blank_input()
	move.move = Vector2.RIGHT
	var dash_move := move.duplicate()
	dash_move.dash = true
	for index in range(30):
		normal.step(DT, move)
		dashed.step(DT, dash_move)
		dash_move.dash = false
	test.expect(normal.player.position.x > 260.0, "held movement physically moves courier")
	test.expect(dashed.player.position.x > normal.player.position.x + 20.0, "dash produces a bounded movement burst")
	test.expect(dashed.player.dash_cooldown > 0.0 and dashed.player.position.x <= dashed.PLAYER_MAX_X, "dash recovery and court bounds apply")
	var body = live_sim()
	body.player.position = Vector2(250, 360)
	body.player.aim = Vector2.UP
	set_puck(body, body.player.position + Vector2(35, 0), Vector2(-500, 0))
	body.step(0.1, blank_input())
	test.expect(body.puck.last_returner == "none" and is_equal_approx(body.puck.velocity.length(), 180.0), "duel body block is weak and not a controlled return")
	test.expect(body.rules.player_score == 0 and body.rules.rival_score == 0, "legal body block does not invent score or damage")


func _test_rally_pylons_precision_and_brake(test: SceneTree) -> void:
	var sim = live_sim()
	sim.player.position = Vector2(250, 360)
	sim.player.aim = Vector2.RIGHT
	set_puck(sim, sim.paddle_center(sim.player) + Vector2(70, 0), Vector2(-600, 0))
	sim.step(0.1, blank_input())
	var first_speed: float = sim.puck.velocity.length()
	set_puck(sim, sim.paddle_center(sim.player) + Vector2(70, 0), Vector2(-first_speed, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rally_hits >= 2 and sim.puck.velocity.length() > first_speed * 1.03, "successive returns escalate rally speed")
	test.expect(sim.puck.velocity.length() <= sim.MAX_SPEED + 0.001, "rally escalation respects speed cap")
	sim = live_sim()
	set_puck(sim, Vector2(560, 260), Vector2(600, 0))
	sim.step(0.2, blank_input())
	test.expect(sim.puck.velocity.x < 0.0 and "pylon" in sim.events, "mid-court pylon creates a bankable rebound")
	sim = live_sim()
	sim.rally_hits = 8
	test.expect(sim.goal_bounds().x < sim.GOAL_TOP, "extended rally creates pressure-wide goals")
	set_puck(sim, Vector2(100, sim.GOAL_TOP - 5), Vector2(-1050, 0))
	sim.step(0.1, blank_input())
	test.expect(sim.rules.rival_score == 1, "pressure opening converts an otherwise blocked edge shot")

	var precise = live_sim()
	precise.player.position = Vector2(250, 360)
	precise.player.aim = Vector2.RIGHT
	set_puck(precise, precise.paddle_center(precise.player) + Vector2(30, 0), Vector2(-600, 0))
	var strike := blank_input()
	strike.strike = true
	precise.step(DT, strike)
	test.expect(precise.last_return_grade == "perfect", "contact in the tight strike window grades PERFECT")
	var late = live_sim()
	late.player.position = Vector2(250, 360)
	late.player.aim = Vector2.RIGHT
	set_puck(late, late.paddle_center(late.player) + Vector2(95, 0), Vector2(-500, 0))
	late.step(DT, strike)
	for index in range(20):
		late.step(DT, blank_input())
	test.expect(late.last_return_grade == "active", "an early strike that still connects grades ACTIVE")

	var control = live_sim()
	var braked = live_sim()
	for runner in [control, braked]:
		runner.player.position = Vector2(250, 360)
		runner.player.aim = Vector2.UP
		set_puck(runner, Vector2(640, 320), Vector2(400, 0))
	braked.brake_energy = 70.0
	var brake_input := blank_input()
	brake_input.technique = true
	braked.step(DT, brake_input)
	control.step(DT, blank_input())
	braked.step(0.2, blank_input())
	control.step(0.2, blank_input())
	test.expect(braked.brake_remaining > 0.0 and braked.brake_energy == 5.0, "E spends focus to activate BRAKE")
	test.expect(braked.puck.position.x < control.puck.position.x - 20.0, "BRAKE visibly slows the hostile core")
	var adaptive = live_sim()
	adaptive.rules.goal("player")
	adaptive.step(0.7, blank_input())
	test.expect(adaptive.ai_tier == 1 and adaptive.ai_speed_cap > adaptive.AI_MAX_SPEED and adaptive.ai_reaction_ticks < adaptive.AI_DELAY_TICKS, "rival physically adapts after conceding a goal")

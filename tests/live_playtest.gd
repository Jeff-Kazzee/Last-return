extends SceneTree
## Input-driven application check. It never assigns scores, puck state, target state, or exits.

var game: Node2D
var ticks := 0
var finished := false
var pause_started := -1
var pause_snapshot: Dictionary = {}
var pause_frozen := false
var pause_checked := false
var pause_seen_ticks := 0
var pause_snapshot_tick := -1
var max_rally_seen := 0
var captures: Array[String] = []
var captured := {}
var output_dir := ProjectSettings.globalize_path("res://artifacts/live")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	DirAccess.make_dir_recursive_absolute(output_dir)
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	physics_frame.connect(_drive)
	_capture("01-title")


func _tap(action: String) -> void:
	var press := InputEventAction.new()
	press.action = action
	press.pressed = true
	Input.parse_input_event(press)
	var release := InputEventAction.new()
	release.action = action
	release.pressed = false
	Input.parse_input_event(release)


func _strength(action: String, value: float) -> void:
	if absf(value) > 0.04:
		Input.action_press(action, clampf(absf(value), 0.0, 1.0))
	else:
		Input.action_release(action)


func _move(direction: Vector2) -> void:
	_strength("move_left", -direction.x if direction.x < 0.0 else 0.0)
	_strength("move_right", direction.x if direction.x > 0.0 else 0.0)
	_strength("move_up", -direction.y if direction.y < 0.0 else 0.0)
	_strength("move_down", direction.y if direction.y > 0.0 else 0.0)


func _release_controls() -> void:
	_move(Vector2.ZERO)
	for action in ["strike", "dash", "technique", "fire"]:
		Input.action_release(action)


func _predict_y(sim: RefCounted, plane_x: float) -> float:
	if sim.puck.velocity.x >= -1.0:
		return 360.0
	var time: float = (plane_x - sim.puck.position.x) / sim.puck.velocity.x
	if time < 0.0 or time > 5.0:
		return sim.puck.position.y
	return sim.Physics.fold_rail_value(sim.puck.position.y + sim.puck.velocity.y * time, sim.TOP + 28.0, sim.BOTTOM - 28.0)


func _aim(direction: Vector2) -> void:
	_strength("aim_left", -direction.x if direction.x < 0.0 else 0.0)
	_strength("aim_right", direction.x if direction.x > 0.0 else 0.0)
	_strength("aim_up", -direction.y if direction.y < 0.0 else 0.0)
	_strength("aim_down", direction.y if direction.y > 0.0 else 0.0)


func _return_input(sim: RefCounted, target: Vector2, home_x: float, use_brake: bool = true) -> void:
	var actor: Dictionary = sim.player
	var aim: Vector2 = (target - actor.position).normalized()
	_aim(aim)
	var plane_x := home_x + 46.0
	var approaching: bool = sim.puck.velocity.x < -1.0
	var desired := Vector2(home_x, 360.0)
	if approaching:
		desired.y = _predict_y(sim, plane_x) - aim.y * 46.0
	var direction: Vector2 = (desired - actor.position) / 65.0
	_move(direction.limit_length(1.0))
	var paddle: Vector2 = sim.paddle_center(actor)
	if approaching and sim.puck.position.distance_to(paddle) < 52.0 and actor.strike_cooldown <= 0.0:
		Input.action_press("strike")
	else:
		Input.action_release("strike")
	if absf(desired.y - actor.position.y) > 190.0 and actor.dash_cooldown <= 0.0:
		Input.action_press("dash")
	else:
		Input.action_release("dash")
	if use_brake and sim.brake_energy >= sim.BRAKE_COST and approaching and sim.puck.position.distance_to(actor.position) < 280.0:
		Input.action_press("technique")
	else:
		Input.action_release("technique")


func _drive() -> void:
	if finished:
		return
	ticks += 1
	max_rally_seen = maxi(max_rally_seen, game.duel.rally_hits)
	if ticks > 21600:
		_finish(false, "timeout before route completion")
		return
	match game.mode:
		"TITLE":
			if ticks % 10 == 1:
				_tap("confirm")
		"DUEL":
			_drive_duel()
		"BREACH":
			_drive_breach()
		"ESCAPED":
			_release_controls()
			if not captured.has("05-departure"):
				_capture("05-departure")
				return
			_finish(true, "input-driven duel and breach completed")


func _drive_duel() -> void:
	if ticks == 240 and game.duel.rules.phase == "LIVE":
		_tap("pause")
		pause_started = ticks
	if pause_started > 0 and not pause_checked and game.duel.rules.paused:
		pause_seen_ticks += 1
		if pause_snapshot.is_empty() and pause_seen_ticks >= 2:
			pause_snapshot = game.duel.snapshot()
			pause_snapshot_tick = ticks
		elif not pause_snapshot.is_empty() and ticks >= pause_snapshot_tick + 12:
			pause_frozen = game.duel.snapshot() == pause_snapshot
			_capture("02-pause")
			pause_checked = true
			_tap("pause")
	if ticks > 300 and not captured.has("duel"):
		_capture("03-duel")
	if game.duel.rules.phase == "FINISHED":
		_release_controls()
		if game.duel.rules.winner() != "player":
			_finish(false, "bot lost duel; no state was forced")
		elif ticks % 10 == 0:
			_tap("confirm")
		return
	var goal := Vector2(1190, 300 if game.duel.rival.position.y > 360.0 else 460)
	_return_input(game.duel, goal, 255.0)


func _drive_breach() -> void:
	if not captured.has("breach"):
		_capture("04-breach")
	if game.breach.failed:
		_finish(false, "bot failed breach; no health or target state was forced")
		return
	if game.breach.exit_open:
		if not captured.has("open"):
			_capture("06-open-exit")
		Input.action_release("strike")
		Input.action_release("dash")
		var direction: Vector2 = (game.breach.exit_center - game.breach.player.position) / 55.0
		_move(direction.limit_length(1.0))
		return
	_return_input(game.breach, game.breach.target_position, 250.0, false)


func _capture(name: String) -> void:
	if DisplayServer.get_name() == "headless":
		captured[name] = true
		return
	captured[name] = true
	RenderingServer.force_draw(true)
	var path := output_dir.path_join(name + ".png")
	var image := root.get_texture().get_image()
	var error := image.save_png(path)
	if error == OK and path not in captures:
		captures.append(path)


func _finish(success: bool, reason: String) -> void:
	if finished:
		return
	finished = true
	_release_controls()
	var player_strikes := 0
	var player_returns := 0
	var perfect_strikes := 0
	var brake_uses := 0
	for event in game.duel.events:
		if event == "strike_player":
			player_strikes += 1
		if event == "perfect_player":
			perfect_strikes += 1
		if event == "brake":
			brake_uses += 1
		if event in ["strike_player", "perfect_player", "return_player"]:
			player_returns += 1
	var report := {"result": "PASS" if success else "FAIL", "reason": reason,
		"ticks": ticks, "fixed_step_hz": 120,
		"duel_score": [game.duel.rules.player_score, game.duel.rules.rival_score],
		"player_strikes": player_strikes, "perfect_strikes": perfect_strikes,
		"brake_uses": brake_uses, "player_returns": player_returns,
		"duel_time": game.duel.rules.match_time, "faults": game.duel.fault_count,
		"max_rally": max_rally_seen,
		"pause_checked": pause_checked,
		"pause_frozen": pause_frozen, "breach_exit_open": game.breach.exit_open,
		"breach_completed": game.breach.completed, "breach_health": game.breach.health,
		"breach_time": game.breach.elapsed, "breach_events": game.breach.events.slice(maxi(0, game.breach.events.size() - 30)),
		"breach_player": game.breach.player, "captures": captures,
		"driver_version": "live-v4-focus-brake",
		"renderer": DisplayServer.get_name(),
		"state_forcing": "none: only Input actions and scene flow"}
	var file := FileAccess.open(output_dir.path_join("report.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "  "))
	file.close()
	print("LIVE PLAYTEST: ", JSON.stringify(report))
	quit(0 if success and pause_frozen and player_strikes + perfect_strikes > 0 else 1)

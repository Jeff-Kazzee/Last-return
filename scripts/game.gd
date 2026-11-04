extends Node2D
## Real application shell: input, scene flow, and presentation only.

const DuelSimulation = preload("res://scripts/simulation/duel_simulation.gd")
const BreachSimulation = preload("res://scripts/simulation/breach_simulation.gd")
const DuelRules = preload("res://scripts/simulation/duel_rules.gd")

const BG := Color("101b20")
const FLOOR := Color("142b30")
const IVORY := Color("f4edda")
const BRASS := Color("d5a85a")
const VERMILION := Color("e56b52")
const TEAL := Color("70c7bd")
const MUTED := Color("8ca5a5")

var mode := "TITLE"
var duel = DuelSimulation.new()
var breach = BreachSimulation.new()
var mouse_aim := false
var debug_view := false
var reduced_effects := false
var trail: Array[Vector2] = []
var font: Font


func _ready() -> void:
	font = ThemeDB.fallback_font
	_configure_input()
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	queue_redraw()


func _action(name: String) -> void:
	if not InputMap.has_action(name):
		InputMap.add_action(name, 0.2)


func _key(name: String, code: Key) -> void:
	_action(name)
	var event := InputEventKey.new()
	event.physical_keycode = code
	InputMap.action_add_event(name, event)


func _mouse(name: String, button: MouseButton) -> void:
	_action(name)
	var event := InputEventMouseButton.new()
	event.button_index = button
	InputMap.action_add_event(name, event)


func _button(name: String, button: JoyButton) -> void:
	_action(name)
	var event := InputEventJoypadButton.new()
	event.button_index = button
	InputMap.action_add_event(name, event)


func _axis(name: String, axis: JoyAxis, value: float) -> void:
	_action(name)
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = value
	InputMap.action_add_event(name, event)


func _configure_input() -> void:
	for pair in [["move_left", KEY_A], ["move_right", KEY_D], ["move_up", KEY_W], ["move_down", KEY_S], ["aim_left", KEY_LEFT], ["aim_right", KEY_RIGHT], ["aim_up", KEY_UP], ["aim_down", KEY_DOWN], ["dash", KEY_SPACE], ["pause", KEY_ESCAPE], ["retry", KEY_R], ["confirm", KEY_ENTER], ["debug", KEY_F3], ["effects", KEY_F4]]:
		_key(pair[0], pair[1])
	_mouse("strike", MOUSE_BUTTON_LEFT)
	_mouse("fire", MOUSE_BUTTON_RIGHT)
	_button("dash", JOY_BUTTON_LEFT_SHOULDER)
	_button("pause", JOY_BUTTON_START)
	_button("confirm", JOY_BUTTON_A)
	_axis("strike", JOY_AXIS_TRIGGER_RIGHT, 1.0)
	_axis("fire", JOY_AXIS_TRIGGER_LEFT, 1.0)
	for pair in [["move_left", JOY_AXIS_LEFT_X, -1.0], ["move_right", JOY_AXIS_LEFT_X, 1.0], ["move_up", JOY_AXIS_LEFT_Y, -1.0], ["move_down", JOY_AXIS_LEFT_Y, 1.0], ["aim_left", JOY_AXIS_RIGHT_X, -1.0], ["aim_right", JOY_AXIS_RIGHT_X, 1.0], ["aim_up", JOY_AXIS_RIGHT_Y, -1.0], ["aim_down", JOY_AXIS_RIGHT_Y, 1.0]]:
		_axis(pair[0], pair[1], pair[2])


func start_duel() -> void:
	duel.reset(424242)
	breach.paused = false
	mode = "DUEL"
	mouse_aim = false
	trail.clear()


func start_breach() -> void:
	breach.reset()
	mode = "BREACH"
	mouse_aim = false
	trail.clear()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mode in ["DUEL", "BREACH"]:
		mouse_aim = true
	if event.is_echo():
		return
	if event.is_action_pressed("debug"):
		debug_view = not debug_view
	if event.is_action_pressed("effects"):
		reduced_effects = not reduced_effects
		trail.clear()
	if event.is_action_pressed("pause"):
		_toggle_pause()
	if event.is_action_pressed("retry"):
		if mode == "BREACH":
			start_breach()
		elif mode in ["DUEL", "ESCAPED"]:
			start_duel()
	if event.is_action_pressed("confirm"):
		if mode == "TITLE":
			start_duel()
		elif mode == "DUEL" and duel.rules.phase == DuelRules.FINISHED and duel.rules.winner() == "player":
			start_breach()
		elif mode == "ESCAPED":
			start_duel()


func _toggle_pause() -> void:
	if mode == "DUEL" and duel.rules.phase != DuelRules.FINISHED:
		if duel.rules.paused:
			duel.rules.resume()
		else:
			duel.rules.pause()
	elif mode == "BREACH" and not breach.completed and not breach.failed:
		breach.paused = not breach.paused


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if mode == "DUEL" and duel.rules.phase != DuelRules.FINISHED:
			duel.rules.pause()
		elif mode == "BREACH":
			breach.paused = true


func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if not connected:
		_notification(NOTIFICATION_APPLICATION_FOCUS_OUT)


func _read_input(actor: Dictionary) -> Dictionary:
	var aim := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if aim.length_squared() > 0.04:
		mouse_aim = false
	elif mouse_aim:
		aim = (get_global_mouse_position() - actor.position).normalized()
	else:
		aim = Vector2.ZERO
	return {"move": Input.get_vector("move_left", "move_right", "move_up", "move_down"),
		"aim": aim, "strike": Input.is_action_just_pressed("strike"),
		"dash": Input.is_action_just_pressed("dash"), "fire": Input.is_action_pressed("fire")}


func _physics_process(delta: float) -> void:
	if mode == "DUEL":
		duel.step(delta, _read_input(duel.player))
		_record_trail(duel.puck.position, duel.rules.phase == DuelRules.LIVE)
	elif mode == "BREACH":
		breach.step(delta, _read_input(breach.player))
		_record_trail(breach.puck.position, breach.puck.active)
		if breach.completed:
			mode = "ESCAPED"
			trail.clear()


func _process(_delta: float) -> void:
	queue_redraw()


func _record_trail(position: Vector2, active: bool) -> void:
	if reduced_effects or not active:
		if not trail.is_empty():
			trail.clear()
		return
	trail.append(position)
	if trail.size() > 10:
		trail.pop_front()


func _draw() -> void:
	if font == null:
		return
	_draw_background()
	match mode:
		"TITLE":
			_draw_title()
		"DUEL":
			_draw_duel()
		"BREACH":
			_draw_breach()
		"ESCAPED":
			_draw_escaped()


func _text(value: String, position: Vector2, size: int = 18, color: Color = IVORY) -> void:
	draw_string(font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func _center(value: String, y: float, size: int = 24, color: Color = IVORY) -> void:
	var width := font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
	_text(value, Vector2(640.0 - width * 0.5, y), size, color)


func _draw_background() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), BG)
	for index in range(9):
		var x := 30.0 + index * 155.0
		draw_line(Vector2(x, 80), Vector2(x + 35, 680), Color(0.12, 0.20, 0.21, 0.55), 2.0)
	for x in [55.0, 1225.0]:
		draw_circle(Vector2(x, 100), 34, Color("1d3033"))
		draw_arc(Vector2(x, 100), 27, 0, TAU, 48, BRASS.darkened(0.45), 2.0, true)
	_text("LAST STATION  /  OFFLINE", Vector2(28, 30), 13, MUTED)
	_text("F4 EFFECTS " + ("LOW" if reduced_effects else "FULL"), Vector2(1100, 30), 12, MUTED)


func _draw_title() -> void:
	_center("L A S T   R E T U R N", 195, 52, IVORY)
	_center("THE CITY MOVES FIRST.", 242, 18, BRASS)
	var center := Vector2(640, 360)
	draw_circle(center, 17, IVORY)
	draw_arc(center, 26, 0, TAU, 48, BRASS, 3, true)
	draw_line(Vector2(510, 360), Vector2(602, 360), TEAL, 3, true)
	draw_line(Vector2(678, 360), Vector2(770, 360), VERMILION, 3, true)
	draw_line(Vector2(520, 320), Vector2(520, 400), IVORY, 12, true)
	_center("READ THE SHOT.  POSITION.  RETURN WITH PURPOSE.", 450, 20, IVORY)
	_center("ENTER  —  BEGIN THE FIRST COURT", 508, 23, BRASS)
	_center("WASD move   •   Mouse / arrows aim   •   Left click strike   •   Space dash", 574, 16, MUTED)
	_center("Escape pause   •   R retry   •   Gamepad supported", 604, 16, MUTED)
	_center("One first-to-five duel + one connected return breach", 664, 14, MUTED)


func _draw_court() -> void:
	draw_rect(Rect2(65, 85, 1150, 590), Color("0c1418"))
	draw_rect(Rect2(90, 110, 1100, 540), FLOOR)
	draw_rect(Rect2(90, 110, 550, 540), Color(0.12, 0.30, 0.31, 0.15))
	draw_line(Vector2(90, 110), Vector2(1190, 110), IVORY, 3, true)
	draw_line(Vector2(90, 650), Vector2(1190, 650), IVORY, 3, true)
	for x in [90.0, 1190.0]:
		draw_line(Vector2(x, 110), Vector2(x, 285), IVORY, 4, true)
		draw_line(Vector2(x, 475), Vector2(x, 650), IVORY, 4, true)
		for y in [285.0, 475.0]:
			draw_circle(Vector2(x, y), 12, BRASS)
	for y in range(125, 640, 28):
		draw_line(Vector2(640, y), Vector2(640, y + 13), MUTED.darkened(0.35), 2, true)
	draw_arc(Vector2(640, 380), 72, 0, TAU, 64, MUTED.darkened(0.45), 2, true)
	_text("YOUR GATE", Vector2(28, 385), 12, TEAL)
	_text("RIVAL GATE", Vector2(1198, 385), 12, VERMILION)


func _draw_duel() -> void:
	_draw_court()
	_text("COURIER", Vector2(385, 62), 15, TEAL)
	_text("THE RUNNER", Vector2(785, 62), 15, VERMILION)
	_center(str(duel.rules.player_score) + "  :  " + str(duel.rules.rival_score), 76, 42, IVORY)
	_draw_actor(duel.player, true)
	_draw_actor(duel.rival, false)
	_draw_puck(duel.puck.position, true)
	if debug_view:
		_draw_duel_debug()
	match duel.rules.phase:
		DuelRules.READY:
			_center("SERVE  /  " + str(maxi(1, ceili(duel.rules.ready_remaining))), 240, 20, BRASS)
		DuelRules.GOAL_FREEZE:
			_center("POINT  /  " + duel.rules.last_scorer.to_upper(), 240, 22, BRASS)
		DuelRules.FINISHED:
			draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.04, 0.05, 0.78))
			if duel.rules.winner() == "player":
				_center("ROUTE UNSEALED", 300, 40, IVORY)
				_center("The Runner yields. A signal sentry holds the next room.", 350, 18, MUTED)
				_center("ENTER  —  CONNECTED BREACH", 420, 24, BRASS)
			else:
				_center("SIGNAL LOST", 300, 40, IVORY)
				_center("Every return begins with position.", 350, 18, MUTED)
				_center("R  —  INSTANT REMATCH", 420, 24, BRASS)
	if duel.rules.paused:
		_draw_pause()
	_text("WASD move  •  Aim mouse/arrows  •  Click strike  •  Space dash  •  Esc pause  •  R retry", Vector2(190, 700), 14, MUTED)


func _draw_actor(actor: Dictionary, is_player: bool) -> void:
	var color := TEAL if is_player else VERMILION
	var paddle: Vector2 = actor.position + actor.aim * 46.0
	var across: Vector2 = actor.aim.orthogonal().normalized()
	if actor.recoil > 0.0:
		draw_circle(actor.position, 27, Color(color, 0.25))
	draw_circle(actor.position, 18, BG)
	draw_arc(actor.position, 18, 0, TAU, 32, color, 3, true)
	draw_line(actor.position - across * 9, actor.position + across * 9, IVORY if is_player else color, 8, true)
	draw_line(paddle - across * 26, paddle + across * 26, BG, 12, true)
	draw_line(paddle - across * 26, paddle + across * 26, IVORY, 7, true)
	if actor.strike_remaining > 0.0:
		draw_arc(paddle, 34, 0, TAU, 32, BRASS, 3, true)
	elif actor.strike_cooldown <= 0.0:
		draw_circle(paddle + actor.aim * 10, 3, BRASS)


func _draw_puck(position: Vector2, active: bool) -> void:
	if not active:
		return
	if not reduced_effects:
		for index in range(trail.size()):
			var alpha := float(index + 1) / float(trail.size() + 1) * 0.22
			draw_circle(trail[index], 5, Color(IVORY, alpha))
	draw_circle(position, 15, Color(BRASS, 0.24))
	draw_circle(position, 11, BG)
	draw_circle(position, 8, IVORY)


func _draw_duel_debug() -> void:
	draw_arc(duel.puck.position, 10, 0, TAU, 20, VERMILION, 1, true)
	for actor in [duel.player, duel.rival]:
		draw_arc(actor.position, 17, 0, TAU, 20, TEAL, 1, true)
		draw_arc(actor.position + actor.aim * 46.0, 26, 0, TAU, 24, BRASS, 1, true)
	draw_line(duel.rival.position, duel.ai_target, VERMILION, 1, true)
	_text("F3  " + duel.rules.phase + "  CORE " + str(snappedf(duel.puck.velocity.length(), 0.1)) + "  CONTACTS " + str(duel.contact_count), Vector2(105, 135), 13, BRASS)



func _draw_breach() -> void:
	draw_rect(Rect2(65, 85, 1150, 590), Color("0c1418"))
	draw_rect(Rect2(90, 110, 1100, 540), FLOOR)
	for y in [110.0, 650.0]:
		draw_line(Vector2(90, y), Vector2(1190, y), IVORY, 3, true)
	for x in [90.0, 1190.0]:
		draw_line(Vector2(x, 110), Vector2(x, 650), IVORY.darkened(0.2), 3, true)
	_text("CONNECTED BREACH  /  SIGNAL SENTRY", Vector2(90, 62), 18, BRASS)
	_text("INTEGRITY", Vector2(960, 60), 13, MUTED)
	for index in range(3):
		draw_rect(Rect2(1050 + index * 34, 43, 24, 18), TEAL if index < breach.health else Color("314247"))
	var sentry_color := MUTED if breach.sentry_stun > 0.0 else VERMILION
	draw_circle(breach.sentry_position, 30, BG)
	draw_arc(breach.sentry_position, 27, 0, TAU, 6, sentry_color, 5, true)
	draw_line(breach.sentry_position + Vector2(-16, 0), breach.sentry_position + Vector2(16, 0), sentry_color, 4, true)
	_text("SENTRY", breach.sentry_position + Vector2(-38, -43), 12, sentry_color)
	if breach.target_alive:
		draw_circle(breach.target_position, 45, BG)
		draw_arc(breach.target_position, 42, 0, TAU, 12, BRASS, 5, true)
		draw_arc(breach.target_position, 25, 0, TAU, 32, IVORY, 3, true)
		draw_line(breach.target_position + Vector2(-13, -13), breach.target_position + Vector2(13, 13), BRASS, 4, true)
		draw_line(breach.target_position + Vector2(-13, 13), breach.target_position + Vector2(13, -13), BRASS, 4, true)
		_text("RETURNED CORE ONLY", breach.target_position + Vector2(-85, 72), 12, BRASS)
	else:
		draw_arc(breach.target_position, 34, 0.2, 2.5, 20, MUTED, 3, true)
		_text("MECHANISM BROKEN", breach.target_position + Vector2(-80, 65), 12, TEAL)
	var door_color := TEAL if breach.exit_open else MUTED
	draw_rect(Rect2(1098, 515, 68, 100), Color(BG, 0.8))
	draw_arc(breach.exit_center, 48, 0, TAU, 4, door_color, 3, true)
	if not breach.exit_open:
		for x in [1112.0, 1130.0, 1148.0]:
			draw_line(Vector2(x, 528), Vector2(x, 602), door_color, 4, true)
	else:
		_text("EXIT", Vector2(1112, 570), 17, TEAL)
	if breach.puck.active and breach.puck.last_returner == "enemy":
		draw_line(breach.sentry_position, breach.puck.position, Color(VERMILION, 0.20), 2, true)
	_draw_actor(breach.player, true)
	for bolt in breach.bolts:
		draw_rect(Rect2(bolt.position - Vector2(3, 3), Vector2(6, 6)), VERMILION)
	_draw_puck(breach.puck.position, breach.puck.active)
	_text("Left click RETURN  •  Right click sidearm stuns sentry  •  Return the core into the mechanism", Vector2(235, 700), 14, MUTED)
	if breach.failed:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.04, 0.05, 0.8))
		_center("COURIER SIGNAL LOST", 320, 36, IVORY)
		_center("Guard with the paddle. Body hits cost integrity.", 365, 18, MUTED)
		_center("R  —  RETRY AT THE ENTRANCE", 425, 23, BRASS)
	elif breach.paused:
		_draw_pause()


func _draw_pause() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.04, 0.05, 0.78))
	_center("INTERVAL SUSPENDED", 305, 36, IVORY)
	_center("Projectile, rival, timers, and room state are frozen.", 355, 18, MUTED)
	_center("ESC  —  RESUME     R  —  RETRY", 420, 22, BRASS)


func _draw_escaped() -> void:
	_center("D E P A R T U R E   O P E N", 240, 38, IVORY)
	draw_line(Vector2(390, 350), Vector2(890, 350), BRASS, 2, true)
	draw_circle(Vector2(640, 350), 10, IVORY)
	_center("You returned the city's force and opened the route.", 420, 21, TEAL)
	_center("DUEL CLEAR  /  BREACH CLEAR", 470, 17, MUTED)
	_center("ENTER  —  PLAY THE SLICE AGAIN", 540, 22, BRASS)
	_center("Vertical slice complete. The wider campaign is not implemented.", 654, 14, MUTED)


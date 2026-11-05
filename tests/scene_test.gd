extends RefCounted


func run(test: SceneTree) -> void:
	var scene: PackedScene = load("res://scenes/main.tscn")
	var game = scene.instantiate()
	test.root.add_child(game)
	test.expect(game.has_method("start_duel") and game.has_method("start_breach"), "main scene exposes connected slice entry points")
	if not game.has_method("start_duel"):
		game.queue_free()
		return
	test.expect(game.mode == "TITLE", "application launches at title")
	game.start_duel()
	test.expect(game.mode == "DUEL" and game.duel.rules.phase == "READY", "title entry creates clean duel")
	game.duel.rules.pause()
	game.start_breach()
	test.expect(game.mode == "BREACH" and not game.breach.paused, "connected breach starts unpaused after paused duel")
	game.breach.target_alive = false
	game.breach.exit_open = true
	game.breach.player.position = game.breach.exit_center
	game._physics_process(1.0 / 120.0)
	test.expect(game.mode == "ESCAPED", "real main scene connects opened breach exit to route completion")
	game.start_duel()
	test.expect(game.duel.rules.player_score == 0 and game.duel.rules.rival_score == 0, "new match after route completion resets scores")
	game.duel.rules.start()
	game._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	test.expect(game.duel.rules.paused, "focus loss pauses active application duel")
	game.start_breach()
	game._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	test.expect(game.breach.paused, "focus loss pauses active breach")
	game.start_duel()
	game.duel.rules.start()
	game._on_joy_connection_changed(0, false)
	test.expect(game.duel.rules.paused, "controller disconnect pauses active duel")
	game.queue_free()

extends SceneTree
## Visual capture utility only. These state assignments are not gameplay evidence.

var game: Node2D
var output_dir := ProjectSettings.globalize_path("res://artifacts/verification")


func _initialize() -> void:
	call_deferred("_run")


func _save(name: String) -> void:
	await process_frame
	await process_frame
	RenderingServer.force_draw(true)
	var image := root.get_texture().get_image()
	var error := image.save_png(output_dir.path_join(name + ".png"))
	print("CAPTURE ", name, " exit=", error)


func _run() -> void:
	DirAccess.make_dir_recursive_absolute(output_dir)
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await _save("title")
	game.start_duel()
	game.duel.rules.start()
	game.duel.rules.player_score = 2
	game.duel.rules.rival_score = 1
	game.duel.rules.match_time = 41.0
	await _save("duel")
	game.start_breach()
	await _save("breach")
	game.breach.anchors_remaining = 0
	game.breach.anchor_index = game.breach.anchor_positions.size() - 1
	game.breach.target_alive = false
	game.breach.exit_open = true
	await _save("open-exit")
	game.mode = "ESCAPED"
	await _save("departure")
	quit()

extends RefCounted

const BreachSimulation = preload("res://scripts/simulation/breach_simulation.gd")
const DT := 1.0 / 120.0


func run(test: SceneTree) -> void:
	_test_return_ownership_and_exit(test)
	_test_real_paddle_to_target_chain(test)
	_test_pause_and_high_speed(test)
	_test_health_failure_and_retry(test)
	_test_sidearm_and_determinism(test)


func blank_input() -> Dictionary:
	return {"move": Vector2.ZERO, "aim": Vector2.ZERO, "strike": false, "dash": false, "fire": false}


func set_shot(sim: RefCounted, position: Vector2, velocity: Vector2, owner: String) -> void:
	sim.puck.position = position
	sim.puck.velocity = velocity
	sim.puck.last_returner = owner
	sim.puck.active = true
	sim.puck.age = 0.0


func _test_return_ownership_and_exit(test: SceneTree) -> void:
	var sim = BreachSimulation.new()
	test.expect(sim.health == 3 and sim.target_alive and sim.anchors_remaining == 2 and not sim.exit_open, "breach initializes three health, two locks, and a closed exit")
	test.expect(sim.puck.active and sim.puck.last_returner == "enemy", "breach starts with one enemy-owned returnable core")
	sim.player.position = sim.exit_center
	sim.step(DT, blank_input())
	test.expect(not sim.completed, "closed exit cannot complete room")
	sim.player.position = Vector2(240, 500)
	set_shot(sim, sim.target_position + Vector2(-90, 0), Vector2(500, 0), "enemy")
	sim.step(0.1, blank_input())
	test.expect(sim.target_alive and not sim.exit_open, "negative control: enemy-owned shot cannot break mechanism")
	var first_lock: Vector2 = sim.target_position
	set_shot(sim, sim.target_position + Vector2(-90, 0), Vector2(500, 0), "player")
	sim.step(0.1, blank_input())
	test.expect(sim.anchors_remaining == 1 and sim.target_alive and not sim.exit_open, "first returned hit damages one lock but keeps exit closed")
	test.expect(sim.target_position != first_lock, "remaining lock changes the required aim")
	set_shot(sim, sim.target_position + Vector2(-90, 0), Vector2(500, 0), "player")
	sim.step(0.1, blank_input())
	test.expect(not sim.target_alive and sim.anchors_remaining == 0 and sim.exit_open, "second player-returned hit breaks both locks and opens exit")
	test.expect(not sim.completed, "target break alone does not teleport player to exit")
	sim.player.position = sim.exit_center
	sim.step(DT, blank_input())
	test.expect(sim.completed, "entering open exit completes breach")


func _test_real_paddle_to_target_chain(test: SceneTree) -> void:
	var sim = BreachSimulation.new()
	sim.player.position = Vector2(650, 360)
	var aim := Vector2(1, -0.2).normalized()
	sim.player.aim = aim
	set_shot(sim, sim.paddle_center(sim.player) + Vector2(80, 0), Vector2(-500, 0), "enemy")
	var input := blank_input()
	input.aim = aim
	input.strike = true
	sim.step(0.1, input)
	test.expect(sim.puck.last_returner == "player" and sim.puck.velocity.x > 0.0, "breach uses real timed paddle return")
	test.expect(sim.health == 3, "paddle contact prevents breach body damage")
	set_shot(sim, sim.target_position + Vector2(-90, 0), Vector2(500, 0), sim.puck.last_returner)
	sim.step(0.1, blank_input())
	test.expect(sim.anchors_remaining == 1 and not sim.exit_open, "actual paddle return ownership damages first lock")
	set_shot(sim, sim.target_position + Vector2(-90, 0), Vector2(500, 0), sim.puck.last_returner)
	sim.step(0.1, blank_input())
	test.expect(sim.exit_open, "second actual ownership-returned hit opens exit")


func _test_pause_and_high_speed(test: SceneTree) -> void:
	var sim = BreachSimulation.new()
	set_shot(sim, sim.target_position + Vector2(-70, 0), Vector2(900, 0), "player")
	sim.paused = true
	var before: Dictionary = sim.snapshot()
	for index in range(30):
		sim.step(DT, blank_input())
	test.expect(sim.snapshot() == before, "breach pause freezes impact, timers, health, and projectiles")
	sim.paused = false
	sim.step(0.1, blank_input())
	test.expect(sim.anchors_remaining == 1 and not sim.exit_open, "maximum-speed returned core cannot tunnel through first lock")
	set_shot(sim, sim.target_position + Vector2(-70, 0), Vector2(900, 0), "player")
	sim.step(0.1, blank_input())
	test.expect(sim.exit_open, "second maximum-speed lock hit opens exit")


func _test_health_failure_and_retry(test: SceneTree) -> void:
	var sim = BreachSimulation.new()
	sim.player.position = Vector2(400, 400)
	sim.player.aim = Vector2.UP
	for hit in range(3):
		sim.invulnerability = 0.0
		set_shot(sim, sim.player.position + Vector2(35, 0), Vector2(-500, 0), "enemy")
		sim.step(0.1, blank_input())
		test.expect(sim.health == 2 - hit, "unguarded body hit removes exactly one health")
		if hit == 0:
			var health_after: int = sim.health
			for repeated in range(10):
				sim.step(DT, blank_input())
			test.expect(sim.health == health_after, "invulnerability prevents repeated damage from one impact")
	test.expect(sim.failed, "third unguarded hit fails room")
	sim.paused = true
	sim.retry()
	test.expect(sim.health == 3 and not sim.failed and not sim.paused, "retry restores health, failure, and pause")
	test.expect(sim.target_alive and sim.anchors_remaining == 2 and not sim.exit_open and not sim.completed, "retry restores both locks and closed exit")
	test.expect(sim.puck.active and sim.puck.last_returner == "enemy" and sim.bolts.is_empty(), "retry resets projectile and sidearm state")


func _test_sidearm_and_determinism(test: SceneTree) -> void:
	var sim = BreachSimulation.new()
	sim.player.position = Vector2(700, 360)
	sim.player.aim = Vector2.RIGHT
	var input := blank_input()
	input.fire = true
	sim.step(DT, input)
	test.expect(sim.bolts.size() == 1, "breach sidearm fires a bounded low-powered bolt")
	test.expect(sim.target_alive, "sidearm does not bypass armored return objective")
	var stun = BreachSimulation.new()
	stun.player.position = Vector2(700, 250)
	stun.player.aim = Vector2.RIGHT
	stun.step(DT, input)
	for index in range(60):
		stun.step(DT, blank_input())
	test.expect(stun.sentry_stun > 0.0, "sidearm bolt visibly stuns sentry without breaking armor")
	var first = BreachSimulation.new()
	var second = BreachSimulation.new()
	var identical := true
	for index in range(600):
		first.step(DT, blank_input())
		second.step(DT, blank_input())
		if index % 20 == 0 and first.snapshot() != second.snapshot():
			identical = false
	test.expect(identical, "identical breach inputs produce identical five-second trace")


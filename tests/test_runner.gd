extends SceneTree

const DuelRules = preload("res://scripts/simulation/duel_rules.gd")
const DuelPhysicsTest = preload("res://tests/duel_physics_test.gd")

var checks := 0
var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func expect(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures.append(label)
		printerr("FAIL: " + label)


func _run() -> void:
	_test_initial_start_and_single_goal()
	_test_pause_resume_and_timers()
	_test_serve_finish_and_retry()
	_test_automatic_authorized_transitions()
	var lifecycle_checks := checks
	var physics_test = DuelPhysicsTest.new()
	physics_test.run(self)
	print("LIFECYCLE INTEGRATION: %d checks, 0 expected failures" % lifecycle_checks)
	print("DUEL TEST TOTAL: %d checks, %d failures" % [checks, failures.size()])
	quit(0 if failures.is_empty() else 1)


func _test_initial_start_and_single_goal() -> void:
	var rules = DuelRules.new()
	expect(rules.phase == "READY", "match initializes READY")
	expect(rules.player_score == 0 and rules.rival_score == 0, "match initializes 0-0")
	expect(not rules.paused and rules.last_scorer == "none", "match initializes unpaused without attribution")
	expect(rules.serve_owner == "player", "player owns initial serve")
	expect(not rules.goal("player"), "goal rejected before LIVE")
	expect(rules.start(), "READY accepts start")
	expect(rules.phase == "LIVE", "start enters LIVE")
	expect(not rules.start(), "duplicate start rejected")
	expect(rules.goal("player"), "LIVE accepts player goal")
	expect(rules.player_score == 1 and rules.rival_score == 0, "only player gains one point")
	expect(rules.phase == "GOAL_FREEZE" and rules.last_scorer == "player", "goal enters attributed freeze")
	expect(rules.serve_owner == "rival", "conceder owns next serve")
	expect(not rules.goal("player") and not rules.goal("rival"), "duplicate goals rejected during freeze")
	expect(rules.player_score == 1 and rules.rival_score == 0, "duplicate signals leave score unchanged")


func _test_pause_resume_and_timers() -> void:
	var rules = DuelRules.new()
	rules.start()
	rules.advance(0.25)
	var before_time: float = rules.match_time
	expect(rules.pause(), "LIVE accepts pause")
	expect(rules.paused and rules.phase == "LIVE", "pause preserves underlying phase")
	expect(not rules.goal("rival"), "paused goal rejected")
	rules.advance(4.0)
	expect(rules.match_time == before_time, "paused match clock frozen")
	expect(rules.player_score == 0 and rules.rival_score == 0, "paused scoring frozen")
	expect(rules.resume(), "paused match resumes")
	expect(not rules.paused and rules.phase == "LIVE", "resume returns to preserved LIVE phase")
	rules.advance(0.25)
	expect(rules.match_time > before_time, "resumed match clock advances")
	rules.goal("rival")
	var freeze_before: float = rules.freeze_remaining
	rules.pause()
	rules.advance(3.0)
	expect(rules.freeze_remaining == freeze_before and rules.phase == "GOAL_FREEZE", "paused goal freeze timer frozen")
	rules.resume()
	rules.advance(0.7)
	expect(rules.phase == "READY", "resumed freeze enters serve READY")


func _test_serve_finish_and_retry() -> void:
	var rules = DuelRules.new()
	rules.start()
	rules.goal("rival")
	expect(rules.rival_score == 1 and rules.player_score == 0, "rival goal attributes only rival")
	expect(not rules.finish(), "nonwinning freeze cannot finish")
	expect(rules.serve(), "nonwinning freeze accepts serve")
	expect(rules.phase == "READY" and rules.rival_score == 1, "serve preserves score and enters READY")
	rules.start()
	for index in range(4):
		rules.goal("rival")
		if index < 3:
			rules.serve()
			rules.start()
	expect(rules.rival_score == 5, "first-to-five target reached")
	expect(rules.phase == "GOAL_FREEZE", "winning goal still resolves through freeze")
	expect(not rules.serve(), "winning freeze cannot serve")
	expect(rules.finish(), "winning freeze finishes")
	expect(rules.phase == "FINISHED", "finish enters FINISHED")
	expect(not rules.start() and not rules.goal("player") and not rules.pause(), "FINISHED rejects accidental gameplay restart")
	expect(rules.player_score == 0 and rules.rival_score == 5, "finished match has one winner")
	rules.pause()
	rules.retry()
	expect(rules.phase == "READY" and not rules.paused, "retry restores initial phase and pause")
	expect(rules.player_score == 0 and rules.rival_score == 0, "retry clears both scores")
	expect(rules.last_scorer == "none" and rules.serve_owner == "player", "retry clears attribution and serve ownership")
	expect(rules.match_time == 0.0, "retry clears match clock")


func _test_automatic_authorized_transitions() -> void:
	var rules = DuelRules.new()
	rules.advance(0.79)
	expect(rules.phase == "READY", "serve countdown does not start early")
	rules.advance(0.02)
	expect(rules.phase == "LIVE", "serve countdown authorizes start")
	rules.goal("player")
	rules.advance(0.64)
	expect(rules.phase == "GOAL_FREEZE", "point resolution does not serve early")
	rules.advance(0.02)
	expect(rules.phase == "READY", "point resolution authorizes nonwinning serve")
	for index in range(4):
		rules.advance(0.81)
		rules.goal("player")
		rules.advance(0.66)
	expect(rules.phase == "FINISHED" and rules.player_score == 5, "fifth goal automatically finishes after freeze")
	var frozen_time: float = rules.match_time
	rules.advance(10.0)
	expect(rules.match_time == frozen_time, "FINISHED does not advance game time")

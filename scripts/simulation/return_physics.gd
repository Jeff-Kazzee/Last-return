extends RefCounted
## Shared analytic projectile/return math used by duels and breaches.

const EPSILON := 0.000001


static func sweep_circle(start: Vector2, motion: Vector2, center: Vector2, radius: float) -> float:
	var offset := start - center
	var a := motion.length_squared()
	if a <= EPSILON:
		return -1.0
	var c := offset.length_squared() - radius * radius
	if c <= 0.0:
		return 0.0
	var b := 2.0 * offset.dot(motion)
	var discriminant := b * b - 4.0 * a * c
	if discriminant < 0.0:
		return -1.0
	var time := (-b - sqrt(discriminant)) / (2.0 * a)
	return time if time >= 0.0 and time <= 1.0 else -1.0


static func reflected(velocity: Vector2, normal: Vector2, speed: float) -> Vector2:
	var direction := velocity - 2.0 * velocity.dot(normal) * normal
	if direction.length_squared() <= EPSILON:
		direction = normal
	return direction.normalized() * speed


static func aimed_return(velocity: Vector2, normal: Vector2, aim: Vector2, speed: float, max_angle: float) -> Vector2:
	var rebound := reflected(velocity, normal, 1.0).normalized()
	var angle := clampf(rebound.angle_to(aim.normalized()), -max_angle, max_angle)
	var directed := rebound.rotated(angle).normalized()
	if directed.dot(normal) < 0.25:
		var side := signf(rebound.cross(aim))
		if side == 0.0:
			side = 1.0
		directed = normal.rotated(side * acos(0.25)).normalized()
	return directed * speed


static func fold_rail_value(value: float, minimum: float, maximum: float) -> float:
	var span := maximum - minimum
	if span <= 0.0:
		return minimum
	var folded := fposmod(value - minimum, span * 2.0)
	if folded > span:
		folded = span * 2.0 - folded
	return minimum + folded


static func plane_time(start_value: float, motion_value: float, plane: float) -> float:
	if absf(motion_value) <= EPSILON:
		return -1.0
	var time := (plane - start_value) / motion_value
	return time if time >= 0.0 and time <= 1.0 else -1.0

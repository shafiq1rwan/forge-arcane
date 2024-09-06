extends Area2D
var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func initialize(dir: Vector2, proj_speed: float):
	direction = dir
	speed = proj_speed
	rotation = direction.angle()

func _process(delta):
	# Move the projectile in the set direction
	position += direction * speed * delta

	# Remove the projectile if it goes off-screen
	if not get_viewport_rect().has_point(position):
		queue_free()

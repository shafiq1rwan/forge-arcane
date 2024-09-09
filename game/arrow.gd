extends Area2D
var enemy_exited: bool = false

var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0
@export var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_force: int = 300
var travelled_distance = 0
var range_travel = 800

func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed

	rotation += dir.angle()

func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta
	travelled_distance += knife_speed * delta
	
	if travelled_distance > range_travel:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, knockback_direction, knockback_force)
		queue_free()

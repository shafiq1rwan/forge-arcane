extends Area2D

@export var speed: float = 100.0
var direction: Vector2
var damage = 1
var travelled_distance = 0
func _ready():
	# Set the bullet to move in the direction it is facing
	direction = direction.normalized()

func _process(delta: float):
	# Move the bullet in the specified direction
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage_player"):
		body.take_damage_player(damage)
		queue_free()

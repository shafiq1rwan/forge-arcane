extends Area2D

var TRAVELLED_DISTANCE = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * GameManager.SHOOTING_SPEED_PLAYER * delta
	
	TRAVELLED_DISTANCE += GameManager.SHOOTING_SPEED_PLAYER * delta
	if TRAVELLED_DISTANCE > GameManager.BULLET_RANGE:
		queue_free()

func _on_body_entered(body):
	queue_free()
	
	if body.has_method("take_damage"):
		body.take_damage()

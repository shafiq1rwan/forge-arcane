extends Area2D

const ARROW = preload("res://game/arrow.tscn")

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		shoot(0)

func shoot(offset: int) -> void:
	var arrow: Area2D = ARROW.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.launch(global_position, Vector2.RIGHT.rotated(deg_to_rad(rotation_degrees + offset)), 400)

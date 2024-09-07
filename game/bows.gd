extends Area2D

const ARROW = preload("res://game/arrow.tscn")
@onready var timer: Timer = $Timer
var is_shoot = true
@onready var sfx_shoot: AudioStreamPlayer2D = $SFXShoot

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot") and is_shoot:
		shoot(0)
		is_shoot = false

func shoot(offset: int) -> void:
	var arrow: Area2D = ARROW.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.launch(global_position, Vector2.RIGHT.rotated(deg_to_rad(rotation_degrees + offset)), 400)
	sfx_shoot.play()

func _on_timer_timeout() -> void:
	is_shoot = true

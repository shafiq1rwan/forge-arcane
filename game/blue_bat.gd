extends CharacterBody2D

var player: Node2D
var BLUEBAT_HP = 1
const SMOKE_EXPLOSION = preload("res://game/smoke_explosion.tscn")

func _ready():
	# Find the player in the scene (make sure the player node is named "Player")
	player = get_node("/root/Game/Player")
	
func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * GameManager.BLUEBAT_SPEED * delta
	move_and_slide()

func take_damage():
	print("BLUEBAT")
	BLUEBAT_HP -= 1
	
	if BLUEBAT_HP == 0:
		queue_free()
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

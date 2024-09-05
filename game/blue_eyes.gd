extends CharacterBody2D

var player: Node2D
var BLUEEYE_HP = 1
const SMOKE_EXPLOSION = preload("res://game/smoke_explosion.tscn")

func _ready():
	# Find the player in the scene (make sure the player node is named "Player")
	player = get_node("/root/Game/Player")
	
func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * GameManager.BLUEEYE_SPEED * delta
	move_and_slide()

func take_damage():
	BLUEEYE_HP -= 1
	
	if BLUEEYE_HP == 0:
		queue_free()
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

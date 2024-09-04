extends CharacterBody2D

var player: Node2D

func _ready():
	# Find the player in the scene (make sure the player node is named "Player")
	player = get_node("/root/Game/Player")
	
func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * GameManager.BLUEEYE_SPEED * delta
	move_and_slide()

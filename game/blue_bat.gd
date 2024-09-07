extends CharacterBody2D

var player: Node2D
var BLUEBAT_HP = 3
const SMOKE_EXPLOSION = preload("res://game/smoke_explosion.tscn")
const STOP_DISTANCE = 40  # Distance at which the enemy stops moving
@onready var blue_bat_hp: ProgressBar = $BlueBatHP

var knockback_velocity: Vector2 = Vector2.ZERO
var is_knocked_back: bool = false
@export var knockback_duration: float = 0.2  # Time to apply knockback
var knockback_timer: float = 0.0

func _ready():
	# Find the player in the scene (make sure the player node is named "Player")
	player = get_node("/root/Game/Player")
	
func _physics_process(delta: float) -> void:
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if is_knocked_back == true:
		velocity = knockback_velocity
		is_knocked_back = false
	else:
		# Only move the enemy if it is farther than the stop distance
		if distance_to_player > STOP_DISTANCE:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * GameManager.BLUEBAT_SPEED * delta
		else:
			velocity = Vector2.ZERO
	
	move_and_slide()

func take_damage(damage, knockback_direction, knockback_force):
	BLUEBAT_HP -= damage
	blue_bat_hp.value = BLUEBAT_HP
	
	# Apply knockback
	knockback_velocity = knockback_direction.normalized() * knockback_force
	is_knocked_back = true
	knockback_timer = knockback_duration
	
	if BLUEBAT_HP == 0:
		queue_free()
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

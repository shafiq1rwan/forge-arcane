extends CharacterBody2D

var player: Node2D
var BLUEEYE_HP = 3
const SMOKE_EXPLOSION = preload("res://game/smoke_explosion.tscn")
const STOP_DISTANCE = 80  # Distance at which the enemy stops moving
const ENERGY_BALL = preload("res://game/energy_ball.tscn")
@export var bullet_offset: Vector2 = Vector2(0, 0) # Offset for bullet spawning

var knockback_velocity: Vector2 = Vector2.ZERO
var is_knocked_back: bool = false
@export var knockback_duration: float = 0.2  # Time to apply knockback
var knockback_timer: float = 0.0
@onready var blue_eye_hp: ProgressBar = $BlueEyeHP
var time_since_last_shot: float = 0.0
@export var shoot_interval: float = 2.0

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
	
	time_since_last_shot += delta
	
	if time_since_last_shot >= shoot_interval:
		shoot_bullet()
		time_since_last_shot = 0.0

func shoot_bullet():
	if not player:
		return
	# Instance the bullet and set its position and direction
	var bullet = ENERGY_BALL.instantiate()
	bullet.position = position + bullet_offset
	bullet.rotation = rotation
	
	# Calculate direction towards the player
	bullet.direction = (player.position - position).normalized()
	
	# Add the bullet to the scene
	get_parent().add_child(bullet)

func take_damage(damage, knockback_direction, knockback_force):
	BLUEEYE_HP -= damage
	blue_eye_hp.value = BLUEEYE_HP
	
	# Apply knockback
	knockback_velocity = knockback_direction.normalized() * knockback_force
	is_knocked_back = true
	knockback_timer = knockback_duration
	
	if BLUEEYE_HP == 0:
		queue_free()
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: int = 300
var direction: Vector2 = Vector2.ZERO
@onready var player_hp: ProgressBar = $HUD/PlayerHP

# Hurt parameters
var is_hurt: bool = false
var hurt_duration: float = 0.5  # How long the hurt animation lasts

# Dodge parameters
var dodge_duration: float = 0.3  # How long the dodge lasts
var dodge_speed_multiplier: float = 2.5  # Speed boost during dodge
var dodge_cooldown: float = 1.0  # Time between dodges
var dodge_timer: float = 0.0
var dodge_direction: Vector2 = Vector2.ZERO  # Stores the direction of the dodge

# Death parameters
var is_dead: bool = false  # Keep track of whether the player is dead

func _physics_process(delta: float) -> void:
	handle_movement(delta)

# Function to handle movement in 4 directions
func handle_movement(delta: float) -> void:
	direction = Vector2.ZERO

	# Horizontal movement
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	elif Input.is_action_pressed("move_left"):
		direction.x -= 1

	# Vertical movement
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	elif Input.is_action_pressed("move_up"):
		direction.y -= 1
		
	if is_hurt == true:
		animated_sprite_2d.play("hurt-right")
		is_hurt = false
		return
		
	if is_dead == true:
		animated_sprite_2d.play("dead-right")
		is_dead == false

	# Normalize direction for diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
		
		if direction.x > 0:  # Moving right
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run-right")
		elif direction.x < 0:  # Moving left
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run-right")  # Flip the right animation for left
		elif direction.y > 0:  # Moving down
			animated_sprite_2d.play("run-down")
		elif direction.y < 0:  # Moving up
			animated_sprite_2d.play("run-up")
	else:
		if GameManager.PLAYER_HP > 0:
			animated_sprite_2d.play("idle")  # Stop the animation when idle

	velocity = direction * GameManager.PLAYER_SPEED * delta
	move_and_slide()

# Function to handle taking damage and playing hurt/dead animation
func take_damage_player(damage: int) -> void:
	GameManager.PLAYER_HP -= damage
	player_hp.value = GameManager.PLAYER_HP
	is_hurt = true
	
	if GameManager.PLAYER_HP == 0:
		is_dead = true

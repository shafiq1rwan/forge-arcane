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

	# Normalize direction for diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
		# Play the appropriate animation based on movement direction
		update_animation(direction)
	else:
		if GameManager.PLAYER_HP > 0:
			animated_sprite_2d.play("idle")  # Stop the animation when idle
		else:
			animated_sprite_2d.play("dead-down")
			if animated_sprite_2d.animation_finished:
				GameManager.IS_PLAYER_DEAD = true

	velocity = direction * GameManager.PLAYER_SPEED * delta
	
	#if Input.is_action_just_pressed("dodge"):
		## If dodging, only apply dodge velocity and do not update movement direction
		#velocity = direction * GameManager.PLAYER_SPEED * dodge_speed_multiplier * delta
		
	move_and_slide()

# Function to handle starting the dodge
func start_dodge() -> void:
	dodge_direction = direction  # Set dodge direction based on current movement

	# Play dodge animation based on direction
	update_dodge_animation(dodge_direction)

# Function to update dodge animation based on direction
func update_dodge_animation(direction: Vector2) -> void:
	if direction.x > 0:  # Dodge right
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("dodge-right")
	elif direction.x < 0:  # Dodge left
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("dodge-right")  # Flip the right dodge animation
	elif direction.y > 0:  # Dodge down
		animated_sprite_2d.play("dodge-down")
	elif direction.y < 0:  # Dodge up
		animated_sprite_2d.play("dodge-up")

# Function to update movement animation based on direction
func update_animation(direction: Vector2) -> void:

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

# Function to handle taking damage and playing hurt/dead animation
func take_damage_player(damage: int) -> void:

	GameManager.PLAYER_HP -= damage
	player_hp.value = GameManager.PLAYER_HP
	animated_sprite_2d.play("dead-down")
	update_hurt_animation(direction)  # Play hurt animation based on direction
	
	if GameManager.PLAYER_HP <= 0:
		# Player is dead, play dead animation
		animated_sprite_2d.play("dead-down")
		Engine.time_scale = 0

	# Hurt lasts for `hurt_duration` seconds
	#await(get_tree().create_timer(hurt_duration))
	#is_hurt = false

# Function to update hurt animation based on direction
func update_hurt_animation(direction: Vector2) -> void:
	print("Masuk hurt")
	if direction.x > 0:  # Hurt right
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("hurt-right")
	elif direction.x < 0:  # Hurt left
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("hurt-right")  # Flip the right hurt animation
	elif direction.y > 0:  # Hurt down
		animated_sprite_2d.play("hurt-down")
	elif direction.y < 0:  # Hurt up
		animated_sprite_2d.play("hurt-up")

# Function to update dead animation based on direction
func update_dead_animation(direction: Vector2) -> void:
	if direction.x > 0:  # Dead right
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("dead-right")
	elif direction.x < 0:  # Dead left
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("dead-right")  # Flip the right dead animation
	elif direction.y > 0:  # Dead down
		animated_sprite_2d.play("dead-down")
	elif direction.y < 0:  # Dead up
		animated_sprite_2d.play("dead-up")

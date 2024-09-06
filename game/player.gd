extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: int = 300
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	#var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var mouse_direction: Vector2 = ((get_global_mouse_position() - global_position).normalized())
	handle_movement(delta)	
# Function to handle movement in 4 directions
func handle_movement(delta) -> void:
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
		animated_sprite_2d.play("idle")  # Stop the animation when idle

	velocity = direction * GameManager.PLAYER_SPEED * delta
	move_and_slide()
	
func update_animation(direction):
	
	if direction.x > 0:  # Moving right
		if direction.y > 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run-right")  # Diagonal down-right
		elif direction.y < 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run-right")    # Diagonal up-right
		else:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run-right")       # Right
			
	elif direction.x < 0:  # Moving left
		if direction.y > 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run-right")  # Diagonal down-left (using flip)
		elif direction.y < 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run-right")    # Diagonal up-left (using flip)
		else:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run-right")       # Left (using flip)
	
	else:  # Vertical movement (no horizontal movement)
		if direction.y > 0:
			animated_sprite_2d.play("run-down")  # Down
		elif direction.y < 0:
			animated_sprite_2d.play("run-up")    # Up
			
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()

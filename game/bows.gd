extends Area2D

# Projectile speed
@export var projectile_speed: float = 400.0
# Time between shots (rate of fire)
@export var fire_rate: float = 0.5

var time_since_last_shot: float = 0.0

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	const BULLET = preload("res://game/arrow.tscn")
	
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

func shoot_projectile():
	const ARROW = preload("res://game/arrow.tscn")
	# Instantiate the projectile
	var projectile = ARROW.instantiate()

	# Set projectile position to the marker's position
	projectile.position = %ShootingPoint.global_position

	# Calculate direction from marker to the mouse
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - %ShootingPoint.global_position).normalized()

	# Set the direction in the projectile script
	if projectile.has_method("initialize"):
		projectile.initialize(direction, projectile_speed)

	# Add the projectile to the scene
	get_parent().add_child(projectile)

extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword: Node2D = $Sword
@onready var attack_animation: AnimationPlayer = $AttackAnimation

var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: int = 300

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var mouse_direction: Vector2 = ((get_global_mouse_position() - global_position).normalized())
	velocity = direction * GameManager.PLAYER_SPEED
	
	if (direction.x < 0):
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
		
	sword.rotation = mouse_direction.angle()
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
	if Input.is_action_just_pressed("melee"):
		attack_animation.play("slash")
		
	move_and_slide()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()

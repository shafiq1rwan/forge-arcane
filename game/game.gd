extends Node2D

@export var enemy_scenes: Array = [preload("res://game/blue_bat.tscn"), preload("res://game/blue_eyes.tscn")]
@onready var spawn_timer: Timer = $SpawnTimer
@onready var room_detector: Area2D = $RoomDetector
@onready var path_follow_2d: PathFollow2D = $SpawnPoint/PathFollow2D

@export var totalEnemy = 10
@export var enemyOnStage = 0
@onready var door_sprite: AnimatedSprite2D = $DoorFront/DoorSprite
@onready var door_collision: CollisionShape2D = $DoorFront/DoorCollision
@onready var pause_menu: CanvasLayer = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # Ensures more random results from randi()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = true
		Engine.time_scale = 0

func _on_room_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		spawn_timer.start()
		room_detector.queue_free()
	
	door_sprite.play("default")
	door_collision.disabled = false
	
func spawnMob():
	# Select a random enemy from the array
	var random_index = randi() % enemy_scenes.size()
	var enemy_scene = enemy_scenes[random_index]
	
	# Instance the selected enemy
	var enemy_instance = enemy_scene.instantiate()
	path_follow_2d.progress_ratio = randf()
	enemy_instance.global_position = path_follow_2d.global_position
	add_child(enemy_instance)
	
	enemyOnStage += 1
	
	if enemyOnStage == totalEnemy:
		spawn_timer.stop()

func _on_spawn_timer_timeout() -> void:
	spawnMob()


func _on_resume_button_pressed() -> void:
	pause_menu.visible = false
	Engine.time_scale = 1

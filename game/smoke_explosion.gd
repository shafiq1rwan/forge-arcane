extends Node2D
@onready var explode_sfx: AudioStreamPlayer2D = $ExplodeSFX

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
	explode_sfx.play()

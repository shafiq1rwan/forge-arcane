extends Control

@onready var bgm: AudioStreamPlayer = $BGM

func _on_start_button_pressed() -> void:
	ScreenTransition.start_transition_to("res://game/game.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_bgm_finished() -> void:
	bgm.play()

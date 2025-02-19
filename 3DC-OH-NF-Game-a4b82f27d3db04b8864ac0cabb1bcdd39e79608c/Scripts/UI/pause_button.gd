extends TextureButton

@export var pause_screen:Control

func _on_button_down() -> void:
	Audio.play("click")

func _on_button_up() -> void:
	get_tree().paused = true
	if is_instance_valid(pause_screen):
		pause_screen.show()

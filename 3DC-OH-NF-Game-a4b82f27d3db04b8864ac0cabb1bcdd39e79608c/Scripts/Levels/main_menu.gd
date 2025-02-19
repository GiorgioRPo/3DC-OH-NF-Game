extends Control

@export var settings:Control

func play() -> void:
	hide()

func _on_play_button_up() -> void:
	play()

func _on_settings_button_up() -> void:
	if is_instance_valid(settings):
		settings.show()

extends Control

@export var settings:Control

func resume() -> void:
	get_tree().paused = false
	hide()

func _on_resume_button_up() -> void:
	resume()

func _on_settings_button_up() -> void:
	if is_instance_valid(settings):
		settings.show()

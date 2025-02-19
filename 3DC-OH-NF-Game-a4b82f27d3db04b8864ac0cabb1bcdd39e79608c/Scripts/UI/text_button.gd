extends Button


func _on_button_down() -> void:
	Audio.play("click")


func _on_mouse_entered() -> void:
	Audio.play("hover")

extends Control

func set_anim_speed(speed):
	$AnimationPlayer.speed_scale = speed

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

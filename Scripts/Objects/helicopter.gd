extends Node2D

@export var obstacle_id:String = "helicopter"
@export var speed:float = 1

func set_anim_speed(speed_to):
	$AnimationPlayer.speed_scale = speed_to

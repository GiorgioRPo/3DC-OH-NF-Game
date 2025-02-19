extends Node2D

var dir := Vector2.ZERO
var speed:int = 200
var life_time:float = 3
var time:float = 0.0

func _physics_process(delta: float) -> void:
	rotation = dir.angle()
	time += delta
	if time >= life_time:
		destroy()
	global_position += delta * speed * dir

func destroy():
	queue_free()
	

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("lol")
	global_position.x = 2000
	global_position.y = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x -= delta * 0.3 * 2404
	if global_position.x < -500:
		queue_free()  # Remove off-screen obstacles

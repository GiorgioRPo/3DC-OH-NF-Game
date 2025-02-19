extends Node2D


## Constants
const SPRITESHEET_LENGTH:int = 601

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x -= delta * Global.node_parent.game_speed * SPRITESHEET_LENGTH
	if global_position.x < -1000:
		queue_free()  # Remove off-screen obstacles

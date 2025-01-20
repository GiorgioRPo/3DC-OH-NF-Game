class_name Obstacle
extends Node2D

## Obstacle ID:
## - cactus		: Instant death
## - jump_pad	: Changes gravity
@export var obstacle_id:String = ""
## For moving objects to have relative movement
@export var custom_speed_multiplier:float = 1.0

## Constants
const SPRITESHEET_LENGTH:int = 2404

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x -= custom_speed_multiplier * delta * Global.node_parent.game_speed * SPRITESHEET_LENGTH
	if global_position.x < -1000:
		queue_free()  # Remove off-screen obstacles

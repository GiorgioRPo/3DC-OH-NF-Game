extends Camera2D

@export_category("Connected Nodes")
## The player node, must be of type CharacterBody2D
@export var player : CharacterBody2D

@export_category("Camera Settings")
## Rect boundaries of the camera around the centre of the level
@export var boundaries : Vector2 = Vector2(512,300)
## Max speed of the camera
@export var max_speed:int = 150
## Sets the distance offset by the mouse (Around the centre of the screen)
@export var mouse_distance:float = 0.02

## Camere Mode Variables
# Used for later when needing to incorporate different themes,
# possibly playing with camera movement
# 0: Idle, 1: Follow
@export var camera_mode:int = 0

# Camera Shake Stuff
var magnitude:float = 0
var timeleft:float = 0
var is_shaking:bool = false

func _ready() -> void:
	rotation_degrees = 180
	Global.camera = self

func _physics_process(delta) -> void:
	if camera_mode == 1:
		if player != null:
			var cam_pos = global_position 
			var ply_pos = player.global_position
			var cam_len = (cam_pos-ply_pos).length()
			var spd = min(cam_len*2, max_speed) + 1 if cam_len < 300 else cam_len*3
			var cam_dir = (ply_pos-cam_pos).normalized()
			global_position += delta*spd*cam_dir
			global_position = ply_pos
			#global_position.x = clamp(global_position.x, -boundaries.x, boundaries.x)
			#global_position.y = clamp(global_position.y, -boundaries.y, boundaries.y)
			
			
			var target_offset = (get_global_mouse_position() - cam_pos)* mouse_distance
			
			var cam_len2 = (offset-target_offset).length()
			var spd2 = min(cam_len2*4, 200) + 20
			offset = offset.move_toward(target_offset, delta * spd2)


func shake(new_magnitude,lifetime):
	if magnitude*timeleft > new_magnitude*lifetime or !Global.screen_shake: return
	
	magnitude = new_magnitude
	timeleft = lifetime
	
	if is_shaking: return
	is_shaking = true
	
	while timeleft > 0 and is_shaking and is_instance_valid(self):
		var pos = Vector2()
		pos.x = randf_range(-magnitude*timeleft,magnitude*timeleft)
		pos.y = randf_range(-magnitude*timeleft,magnitude*timeleft)

		offset.x = pos.x*100
		offset.y = pos.y*100
		rotation = randf_range(-magnitude, magnitude) * timeleft
		timeleft -= get_process_delta_time()
		await get_tree().process_frame
	
	magnitude = 0
	is_shaking = false

extends Node2D

@export var camera:Camera2D
@export var player:Node2D
@export var redflash:Control

# Node to house all the obstacles (and move them according to the speed)
@onready var obstacles = $Obstacles


# Game logic
var game_speed:float = 0.3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.node_parent = self
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		#redflash.flash(.5)
		#camera.shake(0.2,0.3)
		#player.hit(5)
		pass
	if Input.is_action_just_pressed("up"):
		pass
		#player.hit(-5)
	
	for child in obstacles.get_children():
		child.global_position.x -= delta * game_speed * 2404
		if child.global_position.x < -1000:
			child.global_position.x = 2000
	$Floor.material.set_shader_parameter("speed", Vector2(game_speed,0))


func _on_player_just_hit() -> void:
	game_speed = 0
	$CanvasLayer/Restart.show()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

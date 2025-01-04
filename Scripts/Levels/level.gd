extends Node2D

@export var camera:Camera2D
@export var player:Node2D
@export var redflash:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.node_parent = self
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		#redflash.flash(.5)
		#camera.shake(0.2,0.3)
		player.hit(5)
	if Input.is_action_just_pressed("up"):
		player.hit(-5)

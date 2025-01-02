extends CharacterBody2D

# Exports
@export var max_speed:int = 200
@export var acceleration:float = 8
@export var max_health:int = 100

# Movement Variables
var dir := Vector2.ZERO
var speed:float = 200

# Player Properties
var health:int = 100

signal just_hit

func _ready() -> void:
	# Sets Important Variable Values
	Global.player = self
	speed = max_speed
	health = max_health

func _physics_process(delta: float) -> void:
	# Handles Direction and Player Input
	var target_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	dir = dir.move_toward(target_dir, delta*acceleration)
	
	# Handles Horizontal Sprite Flipping
	if dir.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	# Handles Final Movement
	velocity = dir * speed
	move_and_slide()

func hit(dmg:int):
	health -= dmg
	just_hit.emit()

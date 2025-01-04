extends CharacterBody2D

# Exports
@export var max_speed:int = 200
@export var acceleration:float = 8
@export var max_health:int = 100

# Movement Variables
var jump_force:float = -400
var gravity:float = 600 
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

	if not is_on_floor():
		velocity.y += gravity * delta
		print("Your message here")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Handles Final Movement
	velocity.x = dir.x * speed
	move_and_slide()

func hit(dmg:int):
	health -= dmg
	just_hit.emit()

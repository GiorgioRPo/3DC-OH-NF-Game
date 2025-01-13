extends CharacterBody2D

# Exports
@export var max_speed:int = 200
@export var acceleration:float = 8
@export var max_health:int = 100
@export var down_speed:int = 5000

# Movement Variables
var dir := Vector2.ZERO
var speed:float = 200

# Jump Variables
var jump_force:float = -1000
var gravity:float = 5000
var jump_duration:float = 0
const hold_jump_length:float = 0.1
var holding_jump:bool = false
var can_jump:bool = false
var max_jump = 2
var jump_count = 0

var holding_down:bool = false

# Player Properties
var health:int = 100
var dead:bool = false

signal just_hit

func _ready() -> void:
	# Sets Important Variable Values
	Global.player = self
	speed = max_speed
	health = max_health

func set_hitboxes(mode:int=0):
	# mode --> 0: stand, 1: duck
	if mode == 0:
		$Hitbox/Stand.disabled = false
		$Hitbox/StandHead.disabled = false
		$Hitbox/Duck.disabled = true
	elif mode == 1:
		$Hitbox/Stand.disabled = true
		$Hitbox/StandHead.disabled = true
		$Hitbox/Duck.disabled = false

func _physics_process(delta: float) -> void:
	# Handles cases for disabling process
	if dead: return
	
	# Handles Direction and Player Input
	var target_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	dir = dir.move_toward(target_dir, delta*acceleration)
	
	# Ducking Logic
	if Input.is_action_pressed("down"):
		
		holding_down = true
	else:
		holding_down = false
	
	# Logic when in air
	if not is_on_floor():
		set_hitboxes(0)
		$Sprite.animation = "jump"
		velocity.y += gravity * delta
		if holding_down:
			velocity.y += delta * down_speed
		jump_duration += delta
	# Logic when touching ground
	else:
		if holding_down:
			set_hitboxes(1)
			$Sprite.animation = "duck"
		else:
			set_hitboxes(0)
			$Sprite.animation = "run"
		jump_duration = 0
		velocity.y = 0
	
	
	if Input.is_action_pressed("jump"):
		if jump_duration < hold_jump_length and can_jump and !holding_down:
			velocity.y = jump_force
		else:
			can_jump = false
		
		holding_jump = true
	else:
		holding_jump = false
		can_jump = true
	
	# Handles Final Movement
	velocity.x = dir.x * speed
	move_and_slide()

func hit(dmg:int):
	health -= dmg
	just_hit.emit()


func _on_hitbox_area_entered(area: Area2D) -> void:
	$Sprite.play("die")
	just_hit.emit()
	dead = true

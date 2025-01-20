extends Node2D

<<<<<<< Updated upstream
@export var camera:Camera2D
@export var player:Node2D
@export var redflash:Control
=======
@export var camera: Camera2D
@export var player: Node2D
@export var redflash: Control
@export var obstacles: Node2D # A Node2D to manage all the obstacles
@export var animation_player: AnimationPlayer # Manage Level Animations
@export var cactus_obstacle_scenes: Array[PackedScene]  # Assign your obstacle scene here
@export var jump_pad_scene: PackedScene  # Assign your obstacle scene here

@export var spawn_min_interval: float = 1.0  # Minimum spawn interval (seconds)
@export var spawn_max_interval: float = 3.0  # Maximum spawn interval (seconds)
@export var score_label: Label  # Assign a Label node for displaying the score
@export var high_score_label: Label  # Assign a Label node for displaying the high score
@export var score_animation:AnimationPlayer # Assign an AnimationPlayer node for animating the score

@export var is_flipped = false

## Constants
const GAME_SPEED_RAMP_UP:float = 0.05

var high_score: int = 0
var high_score_file: String = "user://high_score.save"

var score: float = 0  # Player's score
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
=======

# Function to spawn a new obstacle
func _spawn_cactus_obstacle() -> void:
	if not cactus_obstacle_scenes:
		print("Error: Obstacle scene is not assigned!")
		return
		
	# Selects a random cactus
	# Probabilities: 6/11 small, 4/11 medium, 1/11 big, 1/11 hird
	var rand_index = 0
	var rng = randf_range(1,11)
	var bird_chance = 2*sqrt(game_speed)
	if rng >= 11- bird_chance:
		rand_index = 3
	elif rng >= 10 - bird_chance:
		rand_index = 2
	elif rng >= 6 - bird_chance:
		rand_index = 1
	var obstacle = cactus_obstacle_scenes[rand_index].instantiate()
	
	obstacle.position = Vector2(1000, 27)  # Spawn at a relative position of 27 (27 is a tested value)
	## Give random speed and height to birds
	if rand_index == 3:
		obstacle.custom_speed_multiplier *= randf_range(0.7,0.9)
		obstacle.position.y -= 54*randi_range(0,3)
	obstacles.add_child(obstacle) # Adds as a child of obstacles node

# Called when the spawn timer times out
func _on_cactus_spawn_timer_timeout() -> void:
	_spawn_cactus_obstacle()
	# Restart the timer with a random interval
	cactus_spawn_timer.start(0.3 / game_speed * randf_range(spawn_min_interval, spawn_max_interval))

func _spawn_jumppad_obstacle() -> void:
	if not jump_pad_scene:
		print("Error: Obstacle scene is not assigned!")
		return
	
	var obstacle = jump_pad_scene.instantiate()
	obstacle.position = Vector2(1000, randf_range(0, -200))  # Spawn at a random relative height
	obstacles.add_child(obstacle) # Adds as a child of obstacles node

# Called when the spawn timer times out
func _on_jumppad_spawn_timer_timeout() -> void:
	_spawn_jumppad_obstacle()
	# Restart the timer with a random interval
	jumppad_spawn_timer.start(randf_range(2.0, 8.0))


func _on_player_change_gravity() -> void:
	_flip_game()
>>>>>>> Stashed changes

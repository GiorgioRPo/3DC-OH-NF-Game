extends Node2D

@export var camera: Camera2D
@export var player: Node2D
@export var redflash: Control
@export var cactus_obstacle_scene: PackedScene  # Assign your obstacle scene here
@export var spawn_min_interval: float = 1.0  # Minimum spawn interval (seconds)
@export var spawn_max_interval: float = 3.0  # Maximum spawn interval (seconds)

# Node to house all the obstacles (and move them according to the speed)

# Game logic
var game_speed: float = 0.3
var spawn_timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.node_parent = self
	print(player.global_position)
	# Setup the spawn timer
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	var obstacle = cactus_obstacle_scene.instantiate()
	add_child(obstacle)
	spawn_timer.one_shot = true  # Ensures it stops after each timeout
	spawn_timer.timeout.connect(self._on_spawn_timer_timeout)  # Connect timeout signal
	spawn_timer.start(randf_range(spawn_min_interval, spawn_max_interval))  # Start the first spawn cycle

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		pass
	if Input.is_action_just_pressed("up"):
		pass
	

	
	$Floor.material.set_shader_parameter("speed", Vector2(game_speed, 0))

func _on_player_just_hit() -> void:
	game_speed = 0
	$CanvasLayer/Restart.show()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

# Function to spawn a new obstacle
func _spawn_obstacle() -> void:
	if not cactus_obstacle_scene:
		print("Error: Obstacle scene is not assigned!")
		return
	
	var obstacle = cactus_obstacle_scene.instantiate()
	obstacle.global_position = Vector2(1000, randf_range(200, 400))  # Spawn at a random height
	add_child(obstacle)

# Called when the spawn timer times out
func _on_spawn_timer_timeout() -> void:
	_spawn_obstacle()
	# Restart the timer with a random interval
	spawn_timer.start(randf_range(spawn_min_interval, spawn_max_interval))

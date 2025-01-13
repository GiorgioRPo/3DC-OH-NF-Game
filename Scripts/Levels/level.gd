extends Node2D

@export var camera: Camera2D
@export var player: Node2D
@export var redflash: Control
@export var cactus_obstacle_scene: PackedScene  # Assign your obstacle scene here
@export var jump_pad_scene: PackedScene  # Assign your obstacle scene here

@export var spawn_min_interval: float = 1.0  # Minimum spawn interval (seconds)
@export var spawn_max_interval: float = 3.0  # Maximum spawn interval (seconds)
@export var score_label: Label  # Assign a Label node for displaying the score
@export var high_score_label: Label  # Assign a Label node for displaying the high score

var high_score: int = 0
var high_score_file: String = "user://high_score.save"

var score: int = 0  # Player's score

# Node to house all the obstacles (and move them according to the speed)

# Game logic
var game_speed: float = 0.3
var last_speed_increase_score: int = 0
var cactus_spawn_timer: Timer
var jumppad_spawn_timer: Timer
var is_game_over = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	high_score = _load_high_score()
	Global.node_parent = self
	score_label.global_position.x = (get_viewport_rect().size / 2)[0] + 500
	score_label.global_position.y = 0
	var obstacle = cactus_obstacle_scene.instantiate()
	add_child(obstacle)
	
	# Setup the spawn timer
	cactus_spawn_timer = Timer.new()
	add_child(cactus_spawn_timer)
	cactus_spawn_timer.one_shot = true  # Ensures it stops after each timeout
	cactus_spawn_timer.timeout.connect(self._on_cactus_spawn_timer_timeout)  # Connect timeout signal
	cactus_spawn_timer.start(randf_range(spawn_min_interval, spawn_max_interval))  # Start the first spawn cycle
	
	
	jumppad_spawn_timer = Timer.new()
	add_child(jumppad_spawn_timer)
	jumppad_spawn_timer.one_shot = true  # Ensures it stops after each timeout
	jumppad_spawn_timer.timeout.connect(self._on_jumppad_spawn_timer_timeout)  # Connect timeout signal
	jumppad_spawn_timer.start(randf_range(2.0, 8.0))  # Start the first spawn cycle

func _save_high_score(score: int) -> void:
	var file = FileAccess.open(high_score_file, FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(str(score))
		file.close()
	else:
		print("Error saving high score!")
		
func _load_high_score() -> int:
	if FileAccess.file_exists(high_score_file):
		var file = FileAccess.open(high_score_file, FileAccess.ModeFlags.READ)
		if file:
			var saved_score = file.get_as_text().to_int()
			file.close()
			return saved_score
	return 0  # Default high score if no file exists

func _process(delta: float) -> void:
	if not is_game_over:
		# Update score
		score += int(delta * 150)

		# Increase game_speed every 1000 score
		if score - last_speed_increase_score >= 1000:
			game_speed += 0.1
			last_speed_increase_score = score
			print("Game speed increased to ", game_speed)
	else:
		cactus_spawn_timer.stop()
		$Floor.material.set_shader_parameter("speed", Vector2(0, 0))
		if score > high_score:
			high_score = score
			_save_high_score(high_score)

	if score_label:
		score_label.text = str(score).pad_zeros(6)
	else:
		print("Score Label is not assigned or does not exist!")
	
	if high_score_label and high_score:
		high_score_label.text = "Hi: " + str(high_score).pad_zeros(6)
	else:
		print("High Score Label is not assigned or does not exist!")
	
	$Floor.material.set_shader_parameter("speed", Vector2(game_speed, 0))

func _on_player_just_hit() -> void:
	is_game_over = true
	game_speed = 0
	$CanvasLayer/Restart.show()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

# Function to spawn a new obstacle
func _spawn_cactus_obstacle() -> void:
	if not cactus_obstacle_scene:
		print("Error: Obstacle scene is not assigned!")
		return
	
	var obstacle = cactus_obstacle_scene.instantiate()
	obstacle.global_position = Vector2(1000, randf_range(200, 400))  # Spawn at a random height
	add_child(obstacle)

# Called when the spawn timer times out
func _on_cactus_spawn_timer_timeout() -> void:
	_spawn_cactus_obstacle()
	# Restart the timer with a random interval
	cactus_spawn_timer.start(randf_range(spawn_min_interval, spawn_max_interval))

func _spawn_jumppad_obstacle() -> void:
	if not jump_pad_scene:
		print("Error: Obstacle scene is not assigned!")
		return
	
	var obstacle = jump_pad_scene.instantiate()
	obstacle.global_position = Vector2(1000, randf_range(200, 400))  # Spawn at a random height
	add_child(obstacle)

# Called when the spawn timer times out
func _on_jumppad_spawn_timer_timeout() -> void:
	_spawn_jumppad_obstacle()
	# Restart the timer with a random interval
	jumppad_spawn_timer.start(randf_range(2.0, 8.0))

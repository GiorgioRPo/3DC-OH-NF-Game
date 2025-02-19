extends Node2D

@export var camera: Camera2D
@export var player: Node2D
@export var redflash: Control
@export var obstacles: Node2D # A Node2D to manage all the obstacles
@export var animation_player: AnimationPlayer # Manage Level Animations
@export var cactus_obstacle_scenes: Array[PackedScene]  # Assign your obstacle scene here
@export var unlockable_obstacle_scenes: Array[PackedScene]
@export var tank_warning_scene: PackedScene
@export var jump_pad_scene: PackedScene  # Assign your obstacle scene here
@export var cloud_scene: PackedScene  # Assign your obstacle scene here

@export var spawn_min_interval: float = 1.5  # Minimum spawn interval (seconds)
@export var spawn_max_interval: float = 2.5  # Maximum spawn interval (seconds)
@export var score_label: Label  # Assign a Label node for displaying the score
@export var high_score_label: Label  # Assign a Label node for displaying the high score
@export var score_animation:AnimationPlayer # Assign an AnimationPlayer node for animating the score

var helicoptering = false
@export var is_flipped = false
@export var is_flipped_x = false
var night:bool = false
var score_to_night:int = 7000

## Constants
const GAME_SPEED_RAMP_UP:float = 0.025

var high_score: int = 0
var high_score_file: String = "user://high_score.save"

var score: float = 0  # Player's score

# Node to house all the obstacles (and move them according to the speed)

# Game logic
var game_speed: float = 0.3
var last_speed_increase_score: int = 0
var cactus_spawn_timer: Timer
var jumppad_spawn_timer: Timer
var cloud_spawn_timer: Timer
var is_game_over = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	high_score = _load_high_score()
	Global.node_parent = self
	score_label.global_position.x = (get_viewport_rect().size / 2)[0] + 500
	score_label.global_position.y = 0
	
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

	cloud_spawn_timer = Timer.new()
	add_child(cloud_spawn_timer)
	cloud_spawn_timer.one_shot = true  # Ensures it stops after each timeout
	cloud_spawn_timer.timeout.connect(self._on_cloud_spawn_timer_timeout)  # Connect timeout signal
	cloud_spawn_timer.start(0.1)  # Start the first spawn cycle

func _flip_game(horizontal=false):
	if horizontal:
		is_flipped_x = !is_flipped_x
		if is_flipped_x:
			animation_player.play("flip_game_3")
		else:
			animation_player.play_backwards("flip_game_3")
		return
	is_flipped = !is_flipped
	if is_flipped:
		animation_player.play("flip_game_2")
	else:
		animation_player.play_backwards("flip_game_2")

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
		# Update score (in float)
		score += delta * 200

		# Increase game_speed every 1000 score
		if score > score_to_night:
			if night:
				score_to_night += 7000
				$NightAnimation.play_backwards("night")
			else:
				score_to_night += 2000
				$NightAnimation.play("night")
			night = !night
		if score - last_speed_increase_score >= 1000:
			if unlockable_obstacle_scenes.size() > 0:
				cactus_obstacle_scenes.append(unlockable_obstacle_scenes[0])
				unlockable_obstacle_scenes.remove_at(0)
			game_speed += GAME_SPEED_RAMP_UP
			Audio.play("point")
			last_speed_increase_score = int(score/1000)*1000 # Ensures that it is rounded to the nearest thousand
			score_animation.play("speed_up")
			print("Game speed increased to ", game_speed)
	else:
		cactus_spawn_timer.stop()
		$Floor.material.set_shader_parameter("speed", Vector2(0, 0))
		if score > high_score:
			high_score = int(score)
			_save_high_score(high_score)

	if score_label:
		### If the score is blinking, then display the last increase score only
		if score_animation.is_playing():
			score_label.text = str(int(last_speed_increase_score)).pad_zeros(6)
		else:
			score_label.text = str(int(score)).pad_zeros(6)
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
func _on_player_restart() -> void:
	_on_restart_pressed()

# Function to spawn a new obstacle
func _spawn_cactus_obstacle() -> void:
	if not cactus_obstacle_scenes:
		print("Error: Obstacle scene is not assigned!")
		return
	
	var time_added = 0
	var obstacle = cactus_obstacle_scenes.pick_random().instantiate()
	if obstacle.obstacle_id == "cactus":
		obstacle.position = Vector2(1000, 27)  # Spawn at a relative position of 27 (27 is a tested value)
	elif obstacle.obstacle_id == "bird":
		obstacle.speed = randf_range(0.8,1.2)
		obstacle.position = Vector2(1000, 27 - randi_range(0,4) * 54)  # Spawn at a relative position of 27 (27 is a tested value)
	elif obstacle.obstacle_id == "tank":
		Global.instance_node(tank_warning_scene, $CanvasLayer).set_anim_speed(game_speed/ 0.3)
		await get_tree().create_timer(3.0 * 0.3 / game_speed).timeout
		obstacle.position = Vector2(1000, 27)
	elif obstacle.obstacle_id == "helicopter":
		if helicoptering:
			helicoptering = false
			obstacle = load("res://Scenes/Objects/Obstacles/Cactus/tank.tscn").instantiate()
			Global.instance_node(tank_warning_scene, $CanvasLayer).set_anim_speed(game_speed/ 0.3)
			await get_tree().create_timer(3.0 * 0.3 / game_speed).timeout
			obstacle.position = Vector2(1000, 27)
		else:
			helicoptering = true
			time_added = -0.9
			obstacle.position = Vector2(1000, 110)
			obstacle.set_anim_speed(game_speed/ 0.3)
	obstacles.add_child(obstacle) # Adds as a child of obstacles node
	
	cactus_spawn_timer.start(time_added + randf_range(spawn_min_interval, spawn_max_interval) * 0.3 / game_speed)

# Called when the spawn timer times out
func _on_cactus_spawn_timer_timeout() -> void:
	_spawn_cactus_obstacle()
	# Restart the timer with a random interval
	

func _spawn_jumppad_obstacle() -> void:
	if not jump_pad_scene:
		print("Error: Obstacle scene is not assigned!")
		return
	
	var obstacle = jump_pad_scene.instantiate()
	obstacle.position = Vector2(1000, randf_range(0, -200))  # Spawn at a random relative height
	obstacles.add_child(obstacle) # Adds as a child of obstacles node

func _spawn_cloud() -> void:
	if not cloud_scene:
		print("Error: Cloud scene is not assigned!")
		return
	
	var obstacle = cloud_scene.instantiate()
	obstacle.position = Vector2(1000, randf_range(-300, -100))  # Spawn at a random relative height
	obstacles.add_child(obstacle) # Adds as a child of obstacles node

# Called when the spawn timer times out
func _on_jumppad_spawn_timer_timeout() -> void:
	_spawn_jumppad_obstacle()
	# Restart the timer with a random interval
	jumppad_spawn_timer.start(randf_range(2.0, 8.0))

func _on_cloud_spawn_timer_timeout() -> void:
	_spawn_cloud()
	# Restart the timer with a random interval
	cloud_spawn_timer.start(randf_range(2.0, 5.0))


func _on_player_change_gravity() -> void:
	var choice = randi_range(0,4)
	var text = ""
	if choice == 0:
		text = "Vertical flip"
		_flip_game()
	elif choice == 1:
		text = "Horizontal flip"
		_flip_game(true)
	elif choice == 2:
		if $Player.scale == Vector2(2,2):
			text = "Back to Normal"
			$Player.scale = Vector2(1,1)
		else:
			text = "Big Dino"
			$Player.scale = Vector2(2,2)
	elif choice == 3:
		text = "Invincibility"
		$Player.activate_rainbow()
	elif choice == 4:
		if $Player.scale == Vector2(0.5,0.5):
			text = "Back to Normal"
			$Player.scale = Vector2(1,1)
		else:
			text = "Mini Dino"
			$Player.scale = Vector2(0.5,0.5)
		
	$CanvasLayer/Powerup.text = text
	$CanvasLayer/Powerup/AnimationPlayer.play("collect")

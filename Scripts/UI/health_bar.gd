extends TextureRect

@export var player:Node2D

var white:float = 0

var have_whited = true


func _ready() -> void:
	white = player.health
	$White.max_value = player.max_health
	$White.value = player.health
	
	player.connect("just_hit", just_hit)

func _process(delta: float) -> void:
	$Health.max_value = player.max_health
	$Health.value = player.health
	
	$White.max_value = player.max_health
	
	if !have_whited:
		white -= delta * $White.max_value/2
		$White.value = white
		if white <= player.health:
			have_whited = true
			white = player.health
			$White.value = white
	elif $White.value < player.health:
		$White.value = player.health

func just_hit() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	have_whited = false

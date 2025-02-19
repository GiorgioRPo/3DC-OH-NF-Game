extends Control

var sliding:bool = false

func _process(_delta: float) -> void:
	if sliding:
		Audio.set_music_volume($Music/music_slider.value)
		Audio.sfx = $SFX/sfx_slider.value

func _ready() -> void:
	show_screen_shake()
	$Music/music_slider.value = Audio.music
	$SFX/sfx_slider.value = Audio.sfx


func _on_slider_drag_started() -> void:
	sliding = true
	Audio.play("click")

func _on_slider_drag_ended(_value_changed: bool) -> void:
	sliding = false
	Audio.play("hover")

func _on_slider_mouse_entered() -> void:
	Audio.play("hover")

func _on_return_button_up() -> void:
	hide()


func _on_screen_shake_button_up() -> void:
	Global.screen_shake = !Global.screen_shake
	show_screen_shake()

func show_screen_shake():
	if Global.screen_shake:
		$ScreenShake.text = "Screen Shake: ON"
	else:
		$ScreenShake.text = "Screen Shake: OFF"

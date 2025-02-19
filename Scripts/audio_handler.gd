extends Node

var music:float = 1
var sfx:float = 1

var audionode = preload("res://Scenes/AudioNode.tscn")

func _ready() -> void:
	set_music_volume(1)

func play(audioname:String, pitch_random:bool = false, volume:int=0,audio_variety:Array[String]=[]):
	if sfx == 0: return
	var file_name = "res://Audio/" + audioname + ".wav"
	if audio_variety.size() >= 1:
		file_name = "res://Audio/" + audioname + "/" + audio_variety.pick_random() + ".wav"
	if !FileAccess.file_exists(file_name):
		print("Audio name [" + file_name + "] does not exist")
		return
	var node_instance = audionode.instantiate()
	node_instance.stream = load(file_name)
	if pitch_random:
		node_instance.pitch_scale *= randf_range(0.9,1.1)
	node_instance.volume_db = volume + (sfx - 1)*(80+volume)/3
	add_child(node_instance)

func set_music_volume(volume:float):
	music = volume
	$BGM.volume_db = volume + (music - 1)*(80+volume)/3
	if music == 0:
		$BGM.volume_db = -80
		$BGM2.volume_db = -80
	

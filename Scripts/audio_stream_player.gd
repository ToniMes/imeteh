extends AudioStreamPlayer

@onready var asp = $AudioStreamPlayer

signal play_sound(sound_name)

func _on_play_sound(sound_name) -> void:
	print("playing sound " + sound_name)
	var sound_file = load("res://Resources/SFX/" + sound_name)
	stream = sound_file
	play()

extends MeshInstance3D

@onready var audio_player = get_node("/root/R&d/Audio/AudioStreamPlayer")

func _ready() -> void:
	audio_player.emit_signal("play_sound", "trolley_running_ambiance.mp3")

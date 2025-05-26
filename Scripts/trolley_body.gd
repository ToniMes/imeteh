extends MeshInstance3D

@onready var sfxStreamPlayer = get_node("/root/R&d/Audio/SfxPlayer")
const AudioEnum = preload("res://Scripts/Audio/audio_enum.gd").AudioEnum

func _ready() -> void:
	sfxStreamPlayer.emit_signal("play_sound", AudioEnum.sfx_trolley_running_ambiance, true)

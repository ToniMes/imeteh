extends MeshInstance3D
class_name Trolley

@onready var turnLever: Lever = $TurnLever
@onready var accLever: Lever = $AccLever
@onready var railWaySpawner: RailWaySpawner = $RailwaySpawner
var leverReady: bool = false
@onready var sfxStreamPlayer = $"../Audio/SfxPlayer"
const AudioEnum = preload("res://Scripts/Audio/audio_enum.gd").AudioEnum
var currentTrack: int = 1 #center


func _ready():
  sfxStreamPlayer.emit_signal("play_sound", AudioEnum.sfx_trolley_running_ambiance, true)
  accLever.prepared = true
  #turnLever.prepared = true


func _process(delta):
  pass
  position.z += delta * 10


func switchTrack(track: int):
  currentTrack = track
  global_position.x = 3 - currentTrack * 3


func turn():
  if turnLever.state == -1:
    switchTrack(0)
  
  elif turnLever.state == 1:
    switchTrack(2)

  else:
    if RandomNumberGenerator.new().randf() < 0.5:
      switchTrack(2)
    else:
      switchTrack(0)
  
  
func prepareLever():
  if turnLever.prepared:
    return
    
  turnLever.prepared = true
  turnLever.targetPosition = turnLever.position + Vector3(0,0.19,0)
  

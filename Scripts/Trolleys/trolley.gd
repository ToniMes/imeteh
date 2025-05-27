extends MeshInstance3D
class_name Trolley

@onready var turnLever: Lever = $TurnLever
@onready var accLever: Lever = $AccLever
@onready var railWaySpawner: RailWaySpawner = $RailwaySpawner
@onready var sfxStreamPlayer = $"../Audio/SfxPlayer"
const AudioEnum = preload("res://Scripts/Audio/audio_enum.gd").AudioEnum
var currentTrack: int = 1 #center
var speed: float = 0


func _ready():
  sfxStreamPlayer.emit_signal("play_sound", AudioEnum.sfx_trolley_running_ambiance, true)
  accLever.prepared = true
  #turnLever.prepared = true


func _process(delta):
  speed = lerp(speed, 10.0 * accLever.state, delta)
  pass
  position.z += delta * speed


func switchTrack(track: int):
  currentTrack = track
  global_position.x = 3 - currentTrack * 3


func turn():
  if turnLever.state == 0:
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
    
  turnLever.visible = true
  turnLever.prepared = true
  turnLever.targetPosition = turnLever.position + Vector3(0,0.19,0)
  

extends MeshInstance3D
class_name Trolley

@onready var turnLever: Lever = $TurnLever
@onready var accLever: Lever = $AccLever
@onready var railWaySpawner: RailWaySpawner = $RailwaySpawner
@onready var narratorPlayer: AudioStreamPlayer = $"../../Audio/NarratorPlayer"
@onready var sfxPlayer: AudioStreamPlayer = $"../../Audio/SfxPlayer"
var currentTrack: int = 1 #center
var speed: float = 0
var started: bool = false
var target_x: float = 0
var target_y: float = 0
var max_speed: float = 10


func _ready():
  accLever.prepared = true
  narratorPlayer.emit_signal("play_sound", "narrator/intro.mp3")


func _process(delta):
  var target_speed = max_speed * accLever.state if accLever.breakingEnabled else max_speed
  speed = lerp(speed, target_speed, delta)
  pass
  position.z -= delta * speed
  global_position.x = lerp(global_position.x, target_x, delta * 10)
  global_position.y = lerp(global_position.y, target_y, delta * 10)
  if speed > 2 and !started:
    started = true
    sfxPlayer.emit_signal("play_sound", "sfx/trolley_running_ambiance.mp3", true)
    
    

func switchTrack(track: int):
  currentTrack = track
  target_x = 2.355 - currentTrack * 2.355


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


func bump():
  target_y = 20
  await get_tree().create_timer(0.1).timeout
  target_y = 0

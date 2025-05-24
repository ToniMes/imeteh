extends MeshInstance3D
class_name Trolley

@onready var lever: Lever = $Lever
@onready var railWaySpawner: RailWaySpawner = $RailwaySpawner
var leverReady: bool = false

var currentTrack: int = 1 #center


func _process(delta):
  pass
  position.z += delta * 10


func switchTrack(track: int):
  currentTrack = track
  global_position.x = 3 - currentTrack * 3


func turn():
  if lever.state == -1:
    switchTrack(0)
  
  elif lever.state == 1:
    switchTrack(2)

  else:
    if RandomNumberGenerator.new().randf() < 0.5:
      switchTrack(2)
    else:
      switchTrack(0)
  
  
func prepareLever():
  if lever.prepared:
    return
    
  lever.prepared = true
  lever.targetPosition = lever.position + Vector3(0,0.19,0)
  

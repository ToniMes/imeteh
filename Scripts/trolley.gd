extends MeshInstance3D
class_name Trolley

@onready var lever: Lever = $Lever
@onready var railWaySpawner: RailWaySpawner = $RailwaySpawner

var currentTrack: int = 1 #center

func _process(delta):
  pass
  position.z += delta * 10


func switchTrack(track: int):
  currentTrack = track
  global_position.x = 3 - currentTrack * 3

func turn():
  
  if lever.state == -1:
    print("turning left")
    switchTrack(0)
  
  elif lever.state == 1:
    print("turning right")
    switchTrack(2)

  else:
    if RandomNumberGenerator.new().randf() < 0.5:
      switchTrack(2)
      print("turning right random")
    else:
      switchTrack(0)
      print("turning left random")

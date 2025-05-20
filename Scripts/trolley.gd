extends MeshInstance3D
class_name Trolley

@onready var playerCamera: XRCamera3D = $Player/XROrigin3D/XRCamera3D
@onready var railWaySpawner: RailWaySpawner = $RailwaySpawner

var currentTrack: int = 1 #center

func _process(delta):
  pass
  position.z += delta * 20
  turn(railWaySpawner.getKnot())


func switchTrack(track: int):
  currentTrack = track
  global_position.x = currentTrack * 3 - 3

func turn(knot: Array[int]):
  #no knot
  if knot[0] == knot[3] and knot[1] == knot[4] and knot[2] == knot[5]:
    return
  
  if playerCamera.rotation.y > 0.5:
    if knot[3] == 1:
      switchTrack(0)
    elif knot[4] == 1:
      switchTrack(1)
    else:
      switchTrack(2)
    return
  
  elif playerCamera.rotation.y < -0.5:
    if knot[5] == 1:
      switchTrack(2)
    elif knot[4] == 1:
      switchTrack(1)
    else:
      switchTrack(0)
    return
  
  else:
    if knot[currentTrack+3] == 0:
      if playerCamera.rotation.y < 0:
        if knot[5] == 1:
          switchTrack(2)
        elif knot[4] == 1:
          switchTrack(1)
        else:
          switchTrack(0)
        return
      elif playerCamera.rotation.y > 0:
        if knot[5] == 1:
          switchTrack(2)
        elif knot[4] == 1:
          switchTrack(1)
        else:
          switchTrack(0)
        return

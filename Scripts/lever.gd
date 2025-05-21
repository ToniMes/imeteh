extends Node3D
class_name Lever

var state: int = 0:
  get:
    return state
  set(value):
    state = value
  
func _process(delta):
  pass
  print(state)

extends Node3D
class_name Lever

@onready var targetPosition: Vector3 = position
@onready var breakingEnabled: bool = true # used to determine if user is allowed to break with the acceleration lever
var prepared: bool = false


var state: int = 0:
  get:
    return state
  set(value):
    state = value

func _process(delta):
  if position.is_equal_approx(targetPosition):
    return
  
  position = position.lerp(targetPosition, delta * 5)

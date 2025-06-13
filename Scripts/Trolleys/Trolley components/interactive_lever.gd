extends InteractiveObject
class_name InteractiveLever

signal lever_switched(direction: Global.LeverDirectionEnum)

var enabled = true
var lever_direction: Global.LeverDirectionEnum = Global.LeverDirectionEnum.NONE
var initial_direction: Global.LeverDirectionEnum = Global.LeverDirectionEnum.NONE

func _process(delta):
  if enabled == false:
    return
    
  # while griped, the lever rotates in the Y plane to follow the hand
  if isGripped and hand:
    physParent.look_at(hand.global_position)
    physParent.rotation.x = 0
    physParent.rotation.z = 0
  
    # the following limits the lever's range of motion
    # to 30 degrees in each direction
    if physParent.rotation.y > PI/6:
      physParent.rotation.y = PI/6
    elif physParent.rotation.y < -PI/6:
      physParent.rotation.y = -PI/6
  
  # otherwise, snap it to left/right
  elif physParent.rotation_degrees.y > 0.01:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, PI/6, delta*8)
  elif physParent.rotation_degrees.y < -0.01:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, -PI/6, delta*8)

  var new_direction = Global.LeverDirectionEnum.RIGHT if physParent.rotation.y > 0 else Global.LeverDirectionEnum.LEFT
  
  # emitting lever_switched if lever switched from left to right or the opposite
  if abs(physParent.rotation.y) - PI/6 < 0.01:
    if lever_direction != Global.LeverDirectionEnum.NONE and new_direction != lever_direction:
      lever_switched.emit(new_direction)
  
  lever_direction = new_direction


func snap(direction: Global.LeverDirectionEnum):
  var rot = 0
  if direction == Global.LeverDirectionEnum.RIGHT:
    rot = PI/6
  elif direction == Global.LeverDirectionEnum.LEFT:
    rot = -PI/6
  physParent.rotation.y = rot

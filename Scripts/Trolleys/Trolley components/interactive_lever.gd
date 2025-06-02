extends InteractiveObject
class_name InteractiveLever

signal lever_switched(state: bool)

var enabled = true
enum LeverDirectionEnum { LEFT, NONE, RIGHT }
var lever_direction: LeverDirectionEnum = LeverDirectionEnum.NONE

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
  elif physParent.rotation_degrees.y > 0:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, PI/6, delta*8)
  elif physParent.rotation_degrees.y <= 0:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, -PI/6, delta*8)

  # if lever is fully left or right
  if abs(physParent.rotation.y) - PI/6 < 0.01:
    var new_direction = LeverDirectionEnum.RIGHT if physParent.rotation.y > 0 else LeverDirectionEnum.LEFT
    
    # emitting lever_switched if lever switched from left to right or the opposite
    if lever_direction != LeverDirectionEnum.NONE and new_direction != lever_direction:
      emit_signal("lever_switched", 0 if physParent.rotation.y >= 0 else 1)
    lever_direction = new_direction

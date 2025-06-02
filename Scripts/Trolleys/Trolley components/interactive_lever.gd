extends InteractiveObject
class_name InteractiveLever

signal lever_switched(state: bool)

var enabled = true
var prev_rotation_y: float
var prev_rotation_y_set: bool = false

func _process(delta):
  if enabled == false:
    return
    
  # setting previous y rotation if not set
  if prev_rotation_y_set == false:
    prev_rotation_y = physParent.rotation.y
    prev_rotation_y_set = true
    
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

  # lever switched if angle is reverse polarity of last one
  if (prev_rotation_y < 0 and physParent.rotation.y > 0) or (prev_rotation_y > 0 and physParent.rotation.y < 0):
    emit_signal("lever_switched", 0 if physParent.rotation.y >= 0 else 1)

  prev_rotation_y = physParent.rotation.y

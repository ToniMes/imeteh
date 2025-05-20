# class decribing the behaviour of a lever
extends InteractiveObject
class_name InteractiveLever


func _process(delta):
  # while griped, the lever rotates in the Y plane to follow the hand
  if isGripped:
    physParent.look_at(hand.global_position)
    physParent.rotation.x = 0
    physParent.rotation.z = 0
  
  # the following limits the lever's range of motion
  # to 45 degrees in each direction
  if physParent.rotation.y > PI/4:
    physParent.rotation.y = PI/4
  if physParent.rotation.y < -PI/4:
    physParent.rotation.y = -PI/4

  # if the lever is released in the -40 to 40 degree range,
  # return it to neutral state
  elif physParent.rotation_degrees.y < 40 and physParent.rotation_degrees.y > -40:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, 0, delta*8)
  
  # otherwise, snap it to left/right
  elif physParent.rotation_degrees.y > 40:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, PI/4, delta*8)
  
  elif physParent.rotation_degrees.y < -40:
    physParent.rotation.y = lerp_angle(physParent.rotation.y, -PI/4, delta*8)

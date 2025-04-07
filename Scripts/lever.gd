#class decribing the behaviour of a lever
extends InteractiveObject
class_name InteractiveLever


#while griped, the lever rotates in the Y plane to follow the hand
func _process(delta):
  if isGripped:
    physParent.look_at(hand.global_position)
    physParent.rotation.x = 0
    physParent.rotation.z = 0

extends InteractiveObject
class_name InteractiveLever


func _process(delta):
  if isGripped:
    physParent.look_at(hand.global_position)
    physParent.rotation.x = 0
    physParent.rotation.z = 0

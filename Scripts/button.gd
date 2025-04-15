extends InteractiveObject
class_name  ClickableButton

func _process(delta):
	# while griped, the lever rotates in the Y plane to follow the hand
  if isGripped:
    physParent.look_at(hand.global_position)
    physParent.translate(Vector3(0, 10, 0))

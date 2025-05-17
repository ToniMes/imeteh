extends InteractiveObject
class_name  ClickableButton
var button_pressed = false

func _process(delta):
  # when gripped, button gets pressed down and comes back up
  if isGripped:
	start_button_press_animation()
	
func start_button_press_animation():
	# skipping animation if button animation is in progress
	if button_pressed:
	  return
	
	button_pressed = true
	var buttonMesh = $ButtonTopMesh
	var original_y = buttonMesh.global_position.y
	
	# creating button animation that pushes it down slightly and then back up
	var tween = create_tween()
	tween.tween_property(buttonMesh, "global_position:y", original_y - 0.01, 0.1)
	tween.tween_property(buttonMesh, "global_position:y", original_y, 0.1).set_delay(0.15)
	tween.tween_callback(func(): 
		button_pressed = false
	)

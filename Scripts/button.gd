extends InteractiveObject
class_name  ClickableButton
var button_pressed = false

func _process(delta):
  # while griped, the lever rotates in the Y plane to follow the hand
  if isGripped and button_pressed == false:
    button_pressed = true
    var buttonMesh = $ButtonTopMesh
    var original_y = buttonMesh.global_position.y
    var tween = create_tween()
    tween.tween_property(buttonMesh, "global_position:y", original_y - 0.01, 0.1)
    tween.tween_property(buttonMesh, "global_position:y", original_y, 0.1).set_delay(0.15)
    tween.tween_callback(func(): 
        print(str(original_y) + " " + str(buttonMesh.global_position.y))
        button_pressed = false
    )

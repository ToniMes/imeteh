extends Node3D
class_name  ClickableButton

var enabled = true # if false button is not clickable
var button_pressed = false
signal buttonPressed
@onready var buttonTop = $PickableObject/ButtonTop

func _process(delta):
  # when gripped, button gets pressed down and comes back up
  if enabled and buttonTop and buttonTop.isGripped and buttonTop.hand:
    start_button_press_animation()
  
  
func start_button_press_animation():
  # skipping animation if button animation is in progress
  if button_pressed:
    return
  
  button_pressed = true
  buttonPressed.emit()
  Global.button_pressed.emit(name)
  var buttonMesh = buttonTop.get_node("ButtonTopMesh")
  var original_y = buttonMesh.global_position.y
  
  # creating button animation that pushes it down slightly and then back up
  var tween = create_tween()
  tween.tween_property(buttonMesh, "global_position:y", original_y - 0.01, 0.1)
  Audio.sfxPlayer.play_sound("sfx/button_press.mp3")
  tween.tween_property(buttonMesh, "global_position:y", original_y, 0.1).set_delay(0.15)
  tween.tween_callback(func(): button_pressed = false)

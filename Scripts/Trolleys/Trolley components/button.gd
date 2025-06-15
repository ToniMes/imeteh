extends Node3D
class_name  ClickableButton

var enabled = true # if false button is not clickable
var button_pressed = false
signal buttonPressed
@onready var buttonTop = $ButtonBody/ButtonTop


func _ready() -> void:
  $ButtonBody/ButtonTop.connect("button_pressed", _on_button_pressed)


func _on_button_pressed():
  # skipping animation if button animation is in progress
  if !enabled or button_pressed:
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

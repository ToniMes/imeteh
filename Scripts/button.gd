extends InteractiveObject
class_name  ClickableButton

@onready var audio_player = get_node("/root/R&d/Audio/AudioStreamPlayer")
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
	audio_player.emit_signal("play_sound", "button_press.mp3")
	tween.tween_property(buttonMesh, "global_position:y", original_y, 0.1).set_delay(0.15)
	tween.tween_callback(func(): button_pressed = false)

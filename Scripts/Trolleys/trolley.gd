extends StaticBody3D
class_name Trolley

@onready var player:PlayerController = $TrolleyBody/Player
@onready var turnLever: StaticLever = $TrolleyBody/TurnLever
@onready var accLever: StaticLever = $TrolleyBody/AccLever
@onready var confetti: Confetti = $Confetti
var currentTrack: int = 0
var speed: float = 0
var started: bool = false
var target_x: float = 0
var target_y: float = 0
var max_speed: float = 10


func _ready() -> void:
  player.left_hand_xr.button_pressed.connect(_on_xr_button_pressed)
  player.right_hand_xr.button_pressed.connect(_on_xr_button_pressed)
  resetCamera()


func switchTrack(track: int):
  currentTrack = track
  target_x = 2.355 - currentTrack * 2.355
  

func turn():
  # turning left if current direction is left or center
  if turnLever.state < 2:
    switchTrack(0)
    
  # turning right if current direction is right
  else:
    switchTrack(2)


func bump():
  target_y = 20
  await get_tree().create_timer(0.1).timeout
  target_y = 0


func prepareTurnLever():
  if turnLever.interactiveLever.enabled == true:
    return
  turnLever.interactiveLever.enabled = true
  turnLever.visible = true
  turnLever.targetPosition = turnLever.position + Vector3(0,0.19,0)
  Global.trolley_direction_changed.emit(turnLever.interactiveLever.lever_direction)


func resetCamera():
  player.origin.global_position = Vector3(0,-0.5,0.5)


func _on_xr_button_pressed(name: String) -> void:
  if name != "trigger" and name != "trigger_click":
    return
  resetCamera()

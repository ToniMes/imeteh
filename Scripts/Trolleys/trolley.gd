extends StaticBody3D
class_name Trolley

@onready var turnLever: StaticLever = $TrolleyBody/TurnLever
@onready var accLever: StaticLever = $TrolleyBody/AccLever
@onready var railWaySpawner: RailWaySpawner = $TrolleyBody/RailwaySpawner
@onready var turnLeverButton: ClickableButton = $TrolleyBody/TurnLeverButton
var currentTrack: int = 0
var speed: float = 0
var started: bool = false
var target_x: float = 0
var target_y: float = 0
var max_speed: float = 10


func _ready():
  accLever.prepared = true
  turnLeverButton.connect("buttonPressed", func(): prepareLever())


func _process(delta):
  #var target_speed = -(max_speed * accLever.state if accLever.breakingEnabled else max_speed)
  #speed = lerp(speed, target_speed, delta)
  #pass
  #position.z -= delta * speed
  #global_position.x = lerp(global_position.x, target_x, delta * 10)
  #global_position.y = lerp(global_position.y, target_y, delta * 10)
  #if speed > 2 and !started:
    #started = true
    #Audio.sfxPlayer.play_sound("sfx/trolley_running_ambiance.mp3", true)
  pass
    
    

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
  
  
func prepareLever():
  if turnLever.prepared:
    return
    
  turnLever.visible = true
  turnLever.prepared = true
  turnLever.targetPosition = turnLever.position + Vector3(0,0.19,0)


func bump():
  target_y = 20
  await get_tree().create_timer(0.1).timeout
  target_y = 0


func _on_acc_lever_lever_switched(state: bool) -> void:
  Global.acc_lever_switched.emit(state)


func _on_turn_lever_button_pressed() -> void:
    Global.trolley_direction_changed.emit(turnLever.state)


func _on_turn_lever_switched(state: bool) -> void:
  var direction: Global.TrolleyDirection
  if state == false:
    direction = Global.TrolleyDirection.LEFT
  else:
    direction = Global.TrolleyDirection.RIGHT
  Global.trolley_direction_changed.emit(direction)

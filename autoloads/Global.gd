extends Node

signal lever_switched(name: String, state: int)
signal button_pressed(name: String)
signal trolley_direction_changed(direction: TrolleyDirection)
signal trolley_acceleration_changed(accelration: int)
signal cabinet_door_state_changed(state: DoorState)
enum TrolleyDirection { LEFT, NONE, RIGHT }
enum LeverDirectionEnum { LEFT, NONE, RIGHT }
enum DoorState { OPEN, CLOSED }
var current_level: int = 0:
  get:
    return current_level
  set(value):
    current_level = value
    print("set value to ", current_level)
@export var audio_controller: AudioController = load("res://Scenes/Audio/audio_controller.tscn").instantiate()
var level_scene: String


func _ready() -> void:
  pass

func connectGlobalSignal(sig: Signal, c: Callable):
  connect(sig.get_name(), c)


func start_next_level():
  current_level += 1
  start_level(current_level)
  
  
func start_level(level: int = current_level):
  current_level = level
  level_scene = "res://Scenes/Levels/lvl" + str(current_level) + ".tscn"
  get_tree().change_scene_to_file(level_scene)

extends Node2D

signal lever_switched(name: String, state: int)
signal button_pressed(name: String)
signal trolley_direction_changed(direction: TrolleyDirection)
signal cabinet_door_state_changed(state: DoorState)
enum TrolleyDirection { LEFT, NONE, RIGHT }
enum DoorState { OPEN, CLOSED }
@export var current_level: int = 0
@export var audio_controller: AudioController = load("res://Scenes/Audio/audio_controller.tscn").instantiate()
var level_scene: String

func connectGlobalSignal(sig: Signal, c: Callable):
  connect(sig.get_name(), c)


func start_next_level():
  Global.current_level += 1
  start_level(Global.current_level)
  
  
func start_level(level: int = current_level):
  level_scene = "res://Scenes/Levels/lvl" + str(level) + ".tscn"
  get_tree().change_scene_to_file(level_scene)

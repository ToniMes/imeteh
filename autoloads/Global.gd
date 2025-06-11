extends Node2D

signal acc_lever_switched(state: bool)
signal trolley_direction_changed(direction: TrolleyDirection)
signal cabinet_door_state_changed(state: DoorState)
enum TrolleyDirection { LEFT, NONE, RIGHT }
enum DoorState { OPEN, CLOSED }
@export var current_level: int = 1
@export var audio_controller: AudioController = load("res://Scenes/Audio/audio_controller.tscn").instantiate()


func connectGlobalSignal(sig: Signal, c: Callable):
  connect(sig.get_name(), c)

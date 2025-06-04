extends Node2D

signal acc_lever_switched(state: bool)
signal trolley_direction_changed(direction: TrolleyDirection)
enum TrolleyDirection { LEFT, NONE, RIGHT }
@export var current_level: int = 1
@export var audio_controller: AudioController = load("res://Scenes/Audio/audio_controller.tscn").instantiate()

extends Node2D

signal player_pulled_speed_lever_for_the_first_time
signal trolley_direction_changed(direction: TrolleyDirection)

var current_level: int = 1

enum TrolleyDirection { LEFT, NONE, RIGHT }

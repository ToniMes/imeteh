extends Node3D
class_name TurnArrow
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func flash():
  animation_player.play("flash")

func turn_off():
  animation_player.play("turn_off")

extends Node3D

@onready var arrow_left: Node3D = $Arrows/ArrowLeft
@onready var arrow_right: Node3D = $Arrows/ArrowRight

func _ready() -> void:
  pass
  
func turning_left():
  arrow_left.flash()
  arrow_right.turn_off()

func turning_right():
  arrow_left.turn_off()
  arrow_right.flash()

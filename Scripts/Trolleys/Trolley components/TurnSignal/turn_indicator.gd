extends Node3D

@onready var arrow_left: Node3D = $Arrows/ArrowLeft
@onready var arrow_right: Node3D = $Arrows/ArrowRight

func _ready() -> void:
  GlobalSignalBus.connect("turning_left", turning_left)
  GlobalSignalBus.connect("turning_right", turning_right)
  
func turning_left():
  print("turning left")
  arrow_left.flash()
  arrow_right.turn_off()

func turning_right():
  print("turning right")
  arrow_left.turn_off()
  arrow_right.flash()

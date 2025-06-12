extends Node3D

@onready var arrow_left: Node3D = $Arrows/ArrowLeft
@onready var arrow_right: Node3D = $Arrows/ArrowRight

func _ready() -> void:
  Global.connect("trolley_direction_changed", _on_trolley_direction_changed)
  
func _on_trolley_direction_changed(direction: Global.TrolleyDirection):
  if direction == Global.TrolleyDirection.RIGHT:
    #print("turning right")
    arrow_left.turn_off()
    arrow_right.flash()
  else:
    #print("turning left")
    arrow_left.flash()
    arrow_right.turn_off()

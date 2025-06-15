extends Node3D
class_name Victim

@onready var model = $Model

var redundancy_protection = true
signal ran_over

func rest_in_peace(body: Node3D):
  if body.name == "Trolley" and redundancy_protection:
    ran_over.emit()
    model.visible = false
    redundancy_protection = false

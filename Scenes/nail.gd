extends Node3D

@onready var head: RigidBody3D = $Head

var nailedFlag = false
signal nailed

func _process(delta):
  if head.position.y < -0.035:
    head.axis_lock_linear_y = true
    head.position.y = -0.035
    if !nailedFlag:
      nailedFlag = true
      nailed.emit()
  elif head.position.y > 0:
    head.position.y = -0

extends Node3D
class_name Maze

@onready var box:StaticBody3D = $Box
@onready var ball:RigidBody3D = $Ball
var AXIS_SPEED = 0.1
var speed = Vector2(0,0)

func _process(delta: float) -> void:
  ball.constant_force = Vector3(speed[0], 0, speed[1]) 

func up():
  speed[1] = AXIS_SPEED
  
func down():
  speed[1] = -AXIS_SPEED

func left():
  speed[0] = AXIS_SPEED
  
func right():
  speed[0] = -AXIS_SPEED


func _on_lab_exit_entered(body: Node3D) -> void:
  if body != ball:
    return
  print("end maze")

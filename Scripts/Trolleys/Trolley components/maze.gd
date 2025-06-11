extends Node3D
class_name Maze

@onready var box:StaticBody3D = $Box
@onready var ball:CharacterBody3D = $Ball
var AXIS_SPEED = 0.1
var speed = Vector2(0,0) # (potitive=right,positive=down)

func _process(delta: float) -> void:
  ball.position.x = ball.position.x + speed[0] * delta
  ball.position.z = ball.position.z + speed[1] * delta

func up():
  speed[1] = -AXIS_SPEED
  
func down():
  speed[1] = AXIS_SPEED

func left():
  speed[0] = -AXIS_SPEED
  
func right():
  speed[0] = AXIS_SPEED


func _on_inner_area_body_exited(body: Node3D) -> void:
  pass
    

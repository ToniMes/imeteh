extends Node3D
class_name Lever

@onready var targetPosition: Vector3 = position
@onready var breakingEnabled: bool = true # used to determine if user is allowed to break with the acceleration lever
@onready var highlightMesh: MeshInstance3D = $PickableObject/XRToolsHighlightVisible/HiglightMesh
@onready var interactiveLever: InteractiveLever = $PickableObject/InteractiveLever
var prepared: bool = false

var state: int = 0:
  get:
    return state
  set(value):
    state = value

func _process(delta):
  if self.name == "LeverTest" and interactiveLever and interactiveLever.enabled == true:
    interactiveLever.enabled = false
  
  if position.is_equal_approx(targetPosition):
    return
  
  position = position.lerp(targetPosition, delta * 5)


func _on_higlight_area_body_entered(body: Node3D) -> void:
  highlightMesh.visible = true


func _on_higlight_area_body_exited(body: Node3D) -> void:
  highlightMesh.visible = false

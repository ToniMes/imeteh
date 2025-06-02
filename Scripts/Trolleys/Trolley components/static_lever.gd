extends Lever
class_name StaticLever

@onready var targetPosition: Vector3 = position
@onready var breakingEnabled: bool = true # used to determine if user is allowed to break with the acceleration lever
@onready var highlightMesh: MeshInstance3D = $Lever/HiglightArea/HighlightMesh
@onready var interactiveLever: InteractiveLever = $Lever/InteractiveLever

var state: int = 0

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

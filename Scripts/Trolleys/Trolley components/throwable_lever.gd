extends Lever
class_name ThrowableLever

@onready var highlightMesh: MeshInstance3D = $Lever/Highlight/HighlightArea/HighlightMesh
    

func _on_higlight_area_body_entered(body: Node3D) -> void:
  highlightMesh.visible = true


func _on_higlight_area_body_exited(body: Node3D) -> void:
  highlightMesh.visible = false

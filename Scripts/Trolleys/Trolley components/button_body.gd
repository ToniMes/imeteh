extends RigidBody3D
class_name HighlightableBody

signal highlight_updated(pickable, enable)


func _on_highlight_area_body_entered(body: Node3D) -> void:
  if body.name == "Hand":
    highlight_updated.emit(self, true)


func _on_highlight_area_body_exited(body: Node3D) -> void:
  if body.name == "Hand":
    highlight_updated.emit(self, false)

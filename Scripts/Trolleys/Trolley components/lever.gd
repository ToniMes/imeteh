extends Node3D
class_name Lever
var lvl

var state: int = 0
var highlightMesh: MeshInstance3D


func _ready():
  lvl = get_tree().root.find_child("Lvl", false, false)


func _on_higlight_area_body_entered(body: Node3D) -> void:
  highlightMesh.visible = true


func _on_higlight_area_body_exited(body: Node3D) -> void:
  highlightMesh.visible = false

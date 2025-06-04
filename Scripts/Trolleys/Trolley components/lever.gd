extends Node3D
class_name Lever

signal lever_switched(state: bool)

var prepared: bool = false
var state: int = 0
var highlightMesh: MeshInstance3D

func _on_interactive_lever_lever_switched(state: bool) -> void:
    self.state = state
    Audio.sfxPlayer.play_sound("sfx/lever_clank.mp3")
    lever_switched.emit(state)


func _on_higlight_area_body_entered(body: Node3D) -> void:
  highlightMesh.visible = true


func _on_higlight_area_body_exited(body: Node3D) -> void:
  highlightMesh.visible = false

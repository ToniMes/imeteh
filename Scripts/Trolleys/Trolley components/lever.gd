extends Node3D
class_name Lever
var lvl

signal lever_switched(name: String, state: bool)

var state: int = 0
var highlightMesh: MeshInstance3D


func _ready():
  lvl = get_tree().root.find_child("Lvl", false, false)


func _on_interactive_lever_lever_switched(name: String, state: int) -> void:
  self.state = 1 if Global.current_level == 1 and lvl.lever_switched_count >= 1 else state
  Audio.sfxPlayer.play_sound("sfx/lever_clank.mp3")
  lever_switched.emit(name, self.state)


func _on_higlight_area_body_entered(body: Node3D) -> void:
  highlightMesh.visible = true


func _on_higlight_area_body_exited(body: Node3D) -> void:
  highlightMesh.visible = false

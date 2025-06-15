extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func switch_to_level(scene_path):
  animation_player.play("fade_in")
  get_tree().change_scene_to_file(scene_path)
  animation_player.play_backwards("fade_in")

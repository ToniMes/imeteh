extends Node3D
class_name Nail

@onready var head: RigidBody3D = $Head
@onready var base = head.position.y

var nailedFlag = true
signal nailed


func _process(delta):
  if head.position.y < -0.025:
    head.axis_lock_linear_y = true
    head.position.y = -0.035
    if !nailedFlag:
      nailedFlag = true
      Audio.sfxPlayer.play_sound("sfx/hammer_shortened.mp3")
      nailed.emit()
  elif head.position.y > 0:
    head.position.y = 0

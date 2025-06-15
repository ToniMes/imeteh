extends Node3D
class_name Nail

@onready var head: RigidBody3D = $Head
@onready var base = head.position.y
var last_position

var nailedFlag = true
signal nailed


func _process(delta):
  if head.position.y < -0.035:
    head.axis_lock_linear_y = true
    head.position.y = -0.035
    if !nailedFlag:
      nailedFlag = true
      nailed.emit()
  elif head.position.y > 0:
    head.position.y = 0
    
  # Slaying sfx if nail is lower then last time
  if last_position and head.position.y < last_position.y:
    Audio.sfxPlayer.play_sound("sfx/hammer_shortened.mp3")
  last_position = head.position

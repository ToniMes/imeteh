# class decribing the behaviour of a lever
extends InteractiveObject
class_name InteractiveLever

@onready var lever: Lever = $"../.."
@onready var sfxPlayer = $"../../Audio/SfxPlayer"

func _process(delta):
  # while griped, the lever rotates in the Y plane to follow the hand
  if isGripped and lever.prepared and hand:
    physParent.look_at(hand.global_position)
    physParent.rotation.x = 0
    physParent.rotation.z = 0
  
    # the following limits the lever's range of motion
    # to 30 degrees in each direction
    if physParent.rotation.y > PI/6:
      physParent.rotation.y = PI/6
      lever.state = 0
    elif physParent.rotation.y < -PI/6:
      physParent.rotation.y = -PI/6
      lever.state = 1
    #elif physParent.rotation_degrees.y < 40 and physParent.rotation_degrees.y > -40:
      #lever.state = 0

  # if the lever is released in the -40 to 40 degree range,
  # return it to neutral state
  #elif physParent.rotation_degrees.y < 25 and physParent.rotation_degrees.y > -25:
    #physParent.rotation.y = lerp_angle(physParent.rotation.y, 0, delta*8)
    #lever.state = 0
  
  # otherwise, snap it to left/right
  elif physParent.rotation_degrees.y > 0:
    if lever.state == 1:
        sfxPlayer.emit_signal("play_sound", "sfx/lever_clank.mp3")
    physParent.rotation.y = lerp_angle(physParent.rotation.y, PI/6, delta*8)
    lever.state = 0
  
  elif physParent.rotation_degrees.y <= 0:
    if lever.state == 0:
        sfxPlayer.emit_signal("play_sound", "sfx/lever_clank.mp3")
    physParent.rotation.y = lerp_angle(physParent.rotation.y, -PI/6, delta*8)
    if lever.name == "AccLever":
      lever.prepared = false
    lever.state = 1

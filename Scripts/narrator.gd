extends Control
class_name Narrator

# How to use:
# Each voice line has the following naming scheme:
# LvlNumber_SequenceCode
# for example, 1_2 would be the second voiceline in the first level
# 1_4b would be an alternate voiceline in response to something the player did
# If a number repeats, for example if there are voicelines 1_2, 1_2a then 1_2a
# can come after 1_2, but does not have to
# However, if there are only 1_9a and 1_9b, then only ONE can be played in the
# sequence of the level

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var subtitles: Label = $Subtitles


var enabled_subtitles: bool = true

func _ready():
  if !enabled_subtitles:
    subtitles.visible = false
  
  Global.should_play_voiceline.connect(play_voiceline)
  Global.should_stop_narrator.connect(stop_narrator)


func play_voiceline(name: String):
  print_debug("Should be playing the voiceline")
  stop_narrator()
  animation_player.play(name)
  
func stop_narrator():
  animation_player.stop(true)
  animation_player.clear_queue()

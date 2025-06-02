extends Lever
class_name StaticLever

@onready var targetPosition: Vector3 = position
@onready var breakingEnabled: bool = true # used to determine if user is allowed to break with the acceleration lever
@onready var interactiveLever: InteractiveLever = $Lever/InteractiveLever

func _ready() -> void:
    highlightMesh = $Lever/HiglightArea/HighlightMesh

func _process(delta):  
  if position.is_equal_approx(targetPosition):
    return
  
  position = position.lerp(targetPosition, delta * 5)


func disable_breaking_if_acc(state: bool) -> void:
     if self.name == "AccLever" and self.breakingEnabled == true:
        sfxPlayer.emit_signal("play_sound", "sfx/broken_breaks.mp3", true)
        breakingEnabled = false

extends Lever
class_name StaticLever

signal lever_switched(name: String, direction: Global.LeverDirectionEnum)

@onready var targetPosition: Vector3 = position
@onready var breakingEnabled: bool = true # used to determine if user is allowed to break with the acceleration lever
@onready var interactiveLever: InteractiveLever = $Lever/InteractiveLever

func _ready() -> void:
  super._ready()
  highlightMesh = $Lever/HiglightArea/HighlightMesh

func _process(delta):  
  if position.is_equal_approx(targetPosition):
    return
  
  position = position.lerp(targetPosition, delta * 5)


func _on_lever_switched(direction: Global.LeverDirectionEnum) -> void:
  Audio.sfxPlayer.play_sound("sfx/lever_clank.mp3")
  lever_switched.emit(name, direction)
  Global.lever_switched.emit(name, direction)
  
  if name == "TurnLever":
    Global.trolley_direction_changed.emit(direction)

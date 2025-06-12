extends Lever
class_name StaticLever

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

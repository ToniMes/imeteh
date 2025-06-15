extends Lever
class_name ThrowableLever


func _ready() -> void:
    highlightMesh = $Lever/Highlight/HighlightArea/HighlightMesh


func disable_grab_points():
  $Lever/LeftGrabPointShaft.enabled = false
  $Lever/LeftGrabPointTip.enabled = false
  $Lever/RightGrabPointShaft.enabled = false
  $Lever/RightGrabPointTip.enabled = false

extends Area3D
class_name InteractiveObject

var physParent: PhysicsBody3D
var hand: StaticBody3D
var isGripped: bool

func _ready():
  physParent = get_parent()


func onHandEnter(body: Node3D):
  if body.name == "Hand":
    hand = body
    hand.get_parent().interactionObject = self


func onHandExit(body: Node3D):
  if body.name == "Hand":
    if body == hand:
      hand.get_parent().interactionObject = null
      hand = null
      isGripped = false


func onTriggerClick():
  isGripped = true


func onTriggerRelease():
  isGripped = false

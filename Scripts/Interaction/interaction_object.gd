# parent class for objects that can be interacted with by the player
extends Area3D
class_name InteractiveObject

var physParent: PhysicsBody3D # the physical object this InteractiveObject is tied to
var hand: StaticBody3D # the hand currently interacting with this object
var isGripped: bool

# assign the physParent
func _ready():
  physParent = get_parent()


# when body enters this area, if it is a hand, assign it
func onHandEnter(body: Node3D):
  if body.name == "Hand":
    hand = body
    #also assign self in the controller instance
    hand.get_parent().interactionObject = self


# break the connection between self and hand on exit
func onHandExit(body: Node3D):
  if body.name == "Hand":
    if body == hand:
      hand.get_parent().interactionObject = null
      hand = null
      #break the grip
      isGripped = false


# should only be called from hand inside this area
func onTriggerClick():
  isGripped = true

# should only be called from hand inside this area
func onTriggerRelease():
  isGripped = false

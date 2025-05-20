extends Node

@onready var hand: StaticBody3D = $Hand
var interactionObject: InteractiveObject
func onButtonPressed(name: String):
  if name == "trigger_click":
  # if interacting with an object, let the object handle the input
    if interactionObject != null:
      interactionObject.onTriggerClick()

func onButtonReleased(name: String):
  if name == "trigger_click":
  # if interacting with an object, let the object handle the input
    if interactionObject != null:
      interactionObject.onTriggerRelease()

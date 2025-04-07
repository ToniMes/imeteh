extends Node

@onready var hand: StaticBody3D = $Hand
var interactionObject: InteractiveObject


func onButtonPressed(name: String):
  if name == "trigger_click":
    if interactionObject != null:
      interactionObject.onTriggerClick()


func onButtonReleased(name: String):
  if name == "trigger_click":
    if interactionObject != null:
      interactionObject.onTriggerRelease()

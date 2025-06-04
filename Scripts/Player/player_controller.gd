extends Node3D
class_name PlayerController

@onready var left_hand_xr: XRController3D = $XROrigin3D/LeftHandXR
@onready var right_hand_xr: XRController3D = $XROrigin3D/RightHandXR
@onready var left_hand: XRToolsHand = $XROrigin3D/LeftHandXR/Hand/LeftHand
@onready var right_hand: XRToolsHand = $XROrigin3D/RightHandXR/Hand/RightHand
@onready var left_pickup: XRToolsFunctionPickup = $XROrigin3D/LeftHandXR/FunctionPickup
@onready var right_pickup: XRToolsFunctionPickup = $XROrigin3D/RightHandXR/FunctionPickup

func _ready():
  pass

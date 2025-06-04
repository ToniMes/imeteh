extends Node3D

@onready var trolley_body:MeshInstance3D  = $Trolley/TrolleyBody
@onready var acc_lever:StaticLever  = $Trolley/TrolleyBody/AccLever
@onready var left_hand:XRToolsHand = $Trolley/TrolleyBody/Player/XROrigin3D/LeftHandXR/Hand/LeftHand
@onready var right_hand:XRToolsHand = $Trolley/TrolleyBody/Player/XROrigin3D/RightHandXR/Hand/RightHand
@onready var left_pickup:XRToolsFunctionPickup = $Trolley/TrolleyBody/Player/XROrigin3D/LeftHandXR/FunctionPickup
@onready var right_pickup:XRToolsFunctionPickup = $Trolley/TrolleyBody/Player/XROrigin3D/RightHandXR/FunctionPickup
var acc_lever_switch_counter = 0

func _ready() -> void:
  Global.current_level = 2


func _on_trolley_acc_lever_switched(state: bool) -> void:
  acc_lever_switch_counter += 1
  
   # breaking the lever if this this is the third lever switch
  if acc_lever_switch_counter == 3:
    var throwable_lever:ThrowableLever = load("res://Scenes/Trolleys/Trolley components/throwable_lever.tscn").instantiate()
    var lever = throwable_lever.get_node("Lever")
    add_child(throwable_lever)
    
    # making closest hand grab the lever
    var left_distance = acc_lever.global_position.distance_to(left_hand.global_position)
    var right_distance = acc_lever.global_position.distance_to(right_hand.global_position)
    trolley_body.remove_child(acc_lever)
    if left_distance < right_distance:
      left_pickup._pick_up_object(lever)
    else:
      right_pickup._pick_up_object(lever)

extends Node3D

@onready var trolley:StaticBody3D  = $Trolley
@onready var trolley_body:MeshInstance3D  = $Trolley/TrolleyBody
@onready var acc_lever:StaticLever  = $Trolley/TrolleyBody/AccLever
@onready var player:PlayerController = $Trolley/TrolleyBody/Player
var acc_lever_switch_counter = 0

func _ready() -> void:
  Global.current_level = 2


func _on_trolley_acc_lever_switched(state: bool) -> void:
  acc_lever_switch_counter += 1
  print("lever switched " + str(acc_lever_switch_counter) + " times")
  
   # breaking the lever if this this is the third lever switch
  if acc_lever_switch_counter == 3:
    var throwable_lever:ThrowableLever = load("res://Scenes/Trolleys/Trolley components/throwable_lever.tscn").instantiate()
    var lever = throwable_lever.get_node("Lever")
    add_child(throwable_lever)
  
    # making closest hand grab the lever
    var left_distance = acc_lever.global_position.distance_to(player.left_hand.global_position)
    var right_distance = acc_lever.global_position.distance_to(player.right_hand.global_position)
    trolley_body.remove_child(acc_lever)
    if left_distance < right_distance:
      player.left_pickup._pick_up_object(lever)
    else:
      player.right_pickup._pick_up_object(lever)

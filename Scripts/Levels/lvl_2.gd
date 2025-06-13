extends Node3D

@onready var trolley:Trolley  = $Trolley
@onready var trolley_body:MeshInstance3D  = trolley.get_node("TrolleyBody")
@onready var turn_lever:StaticLever  = trolley_body.get_node("TurnLever")
@onready var acc_lever:StaticLever  = trolley_body.get_node("AccLever")
@onready var player:PlayerController = trolley_body.get_node("Player")
var acc_lever_switch_counter = 0

func _ready() -> void:
  Global.current_level = 2
  
  # Connecting signals
  Global.connectGlobalSignal(Global.lever_switched, _on_lever_switched)
  
  # Initializing levers
  turn_lever.interactiveLever.snap(Global.LeverDirectionEnum.LEFT)
  acc_lever.interactiveLever.snap(Global.LeverDirectionEnum.RIGHT)

  # Adding chunk mover to the scene
  var chunkMover:ChunkMover = load("res://Scenes/EnvironmentChunks/ChunkMover.tscn").instantiate()
  chunkMover.force_split_count = 12
  add_child(chunkMover)


func _on_lever_switched(name: String, direction: Global.LeverDirectionEnum) -> void:
  if name != "AccLever":
    return
  
  Global.trolley_acceleration_changed.emit(1 if direction == Global.LeverDirectionEnum.LEFT else 0)
  acc_lever_switch_counter += 1
  
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

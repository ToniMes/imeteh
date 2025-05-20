extends Node3D
class_name RailWaySpawner

const RAILWAY = preload("res://Scenes/Railway/Railway.tscn")
@onready var rail_parent_left: Node3D = $"../../RailParentLeft"
@onready var rail_parent_center: Node3D = $"../../RailParentCenter"
@onready var rail_parent_right: Node3D = $"../../RailParentRight"
# when spawing in the railway, we have to keep in mind the offset,
# also making sure that when the railway spawns in, there is an overlap on the first and last plank
var rail_length: float = 3.123
var railCount: int = 0
var rail_parts_center: Array[Node3D] = []
var rail_parts_left: Array[Node3D] = []
var rail_parts_right: Array[Node3D] = []
var movement_speed: float = 0.1
var crossed_distance: float = 0
# flag for "starting the train"
var should_move_railing: float = true

func _ready():
  for i in range(20):
    spawnNextRail()

#old process function
#func _process(_delta):
  ##for rail in rail_parts:
    ##rail.position.z -= movement_speed
  #crossed_distance += movement_speed
  #if crossed_distance >= rail_length:
    #var rail_front = RAILWAY.instantiate()
    #rail_front.position.z += 10 * rail_length
    #rail_parent.add_child(rail_front)
    #rail_parts.insert(0, rail_front)
    #var rail_back = rail_parts.get(rail_parts.size()-1)
    #rail_parts.resize(rail_parts.size()-1)
    #rail_parent.remove_child(rail_back)
    #crossed_distance = 0
  #await get_tree().create_timer(0.5).timeout


func _process(delta):
  var distance_to_front = rail_parts_center[0].global_position.distance_to(global_position)
  if distance_to_front <= 18 * rail_length:
    spawnNextRail()
    while rail_parts_left.size() > 20:
      rail_parent_left.remove_child(rail_parts_left.pop_back())
    while rail_parts_center.size() > 20:
      rail_parent_center.remove_child(rail_parts_center.pop_back())
    while rail_parts_left.size() > 20:
      rail_parent_right.remove_child(rail_parts_right.pop_back())


func spawnNextRail():
  var rail_left
  var rail_center
  var rail_right
  
  if railCount <= 50 or railCount > 60:
    rail_left = Node3D.new()
    rail_center = RAILWAY.instantiate()
    rail_right = Node3D.new()
  elif railCount > 50 and railCount <= 60:
    rail_left = RAILWAY.instantiate()
    rail_center = Node3D.new()
    rail_right = RAILWAY.instantiate()
    
  rail_left.position.z = railCount * rail_length
  rail_parent_left.add_child(rail_left)
  rail_parts_left.insert(0, rail_left)
  
  rail_center.position.z = railCount * rail_length
  rail_parent_center.add_child(rail_center)
  rail_parts_center.insert(0, rail_center)
  
  rail_right.position.z = railCount * rail_length
  rail_parent_right.add_child(rail_right)
  rail_parts_right.insert(0, rail_right)
  
  railCount+=1


func getKnot() -> Array[int]:
  var knot: Array[int]
  if rail_parts_left[rail_parts_left.size()-1].name == "Railway":
    knot.append(1)
  else:
    knot.append(0)
  if rail_parts_center[rail_parts_center.size()-1].name == "Railway":
    knot.append(1)
  else:
    knot.append(0)
  if rail_parts_right[rail_parts_right.size()-1].name == "Railway":
    knot.append(1)
  else:
    knot.append(0)
  
  if rail_parts_left[rail_parts_left.size()-2].name == "Railway":
    knot.append(1)
  else:
    knot.append(0)
  if rail_parts_center[rail_parts_center.size()-2].name == "Railway":
    knot.append(1)
  else:
    knot.append(0)
  if rail_parts_right[rail_parts_right.size()-2].name == "Railway":
    knot.append(1)
  else:
    knot.append(0)
  
  return knot
  
  
  
  
  
  
  
  
  
  
  
  
  

extends Node3D
class_name RailWaySpawner

const RAILWAY = preload("res://Scenes/Railway/Railway.tscn")
const RAILWAYPERSON = preload("res://Scenes/Railway/railway_person.tscn")
const SPLIT = preload("res://Scenes/Railway/RailWayYsplit.tscn")
@onready var trolley = $"../.."
@onready var rail_parent_left: Node3D = $"../../../RailParentLeft"
@onready var rail_parent_center: Node3D = $"../../../RailParentCenter"
@onready var rail_parent_right: Node3D = $"../../../RailParentRight"
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
  
  if railCount <= 172:
    rail_left = Node3D.new()
    rail_center = RAILWAY.instantiate()
    rail_right = Node3D.new()
  elif railCount == 173:
    rail_left = Node3D.new()
    rail_center = SPLIT.instantiate()
    rail_right = Node3D.new()
  else:
    rail_left = RAILWAY.instantiate()
    rail_center = Node3D.new()
    rail_right = RAILWAY.instantiate()
  if railCount == 174:
    rail_left = RAILWAYPERSON.instantiate()
    
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
  if railCount == 100:
    Audio.narrator.play_voiceline("1_5") # Lvl15-NowIsAGoodATimeAsAnyToTellYou…
  if railCount == 115:
    Audio.narrator.play_voiceline("1_6") # Lvl16-I’mHereForYou
  if railCount == 192:
    trolley.turn()
  if railCount == 193 and trolley.currentTrack == 0:
    trolley.bump()
  if railCount == 198:
    if trolley.currentTrack == 0:
      Audio.narrator.play_voiceline("1_9b") # Lvl19b-YouRanHerOver
    if trolley.currentTrack == 2:
      Audio.narrator.play_voiceline("1_9a") # Lvl19a-GrandmaLives

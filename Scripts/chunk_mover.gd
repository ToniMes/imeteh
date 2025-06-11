extends Node3D
class_name ChunkMover

const CHUNK_1 = preload("res://Scenes/EnvironmentChunks/Chunk1.tscn")
const CHUNK_2 = preload("res://Scenes/EnvironmentChunks/Chunk2.tscn")
const CHUNK_3 = preload("res://Scenes/EnvironmentChunks/Chunk3.tscn")
const CHUNK_SPLIT = preload("res://Scenes/EnvironmentChunks/Chunk_split.tscn")
const CHUNK_MERGE = preload("res://Scenes/EnvironmentChunks/Chunk_merge.tscn")
const turn_rotation = PI/4
const turn_offset: float = 2.355

@onready var chunk_parent: Node3D = $ChunkParent
@onready var trolley: Node3D = $"../Trolley"

var split_tracker: Node3D
var chunks: Array[Node3D]

var force_split_count = 1
var chunk_length: float = 49.5
var current_speed: float = 0
var target_speed: float = 0
var max_speed: float = 10
var chunk_count = 0
var target_offset: float = 0
var target_rotation: float = 0

var is_jover = false
var merge = false
var split_check = true
# A class that moves, loads in and loads out chunks of the world

func _ready():
  var chunk1 = CHUNK_1.instantiate()
  var chunk2 = CHUNK_2.instantiate()
  var chunk3 = CHUNK_2.instantiate()
  var chunk4 = CHUNK_2.instantiate()
  chunk1.position.z += chunk_length
  chunk2.position.z += chunk_length * 2
  #chunk3.position.z += chunk_length * 3
  #chunk4.position.z += chunk_length * 4
  chunks.append(chunk1)
  chunks.append(chunk2)
  #chunks.append(chunk3)
  #chunks.append(chunk4)
  chunk_parent.add_child(chunk1)
  chunk_parent.add_child(chunk2)
  #chunk_parent.add_child(chunk3)
  #chunk_parent.add_child(chunk4)
  Global.connectGlobalSignal(Global.acc_lever_switched, on_acc_lever)
  
func _process(delta: float) -> void:
  current_speed = lerp(current_speed, target_speed, delta)
  var posdeg = Util.positiveDeg(rotation_degrees.y)
  var posrad = deg_to_rad(posdeg)
  print(cos(posrad))
  for chunk in chunks:
    chunk.position.z -= current_speed * delta * cos(posrad)
  
  if (posdeg > 35 and posdeg < 325) or posdeg > 325:
      target_rotation = 0
      if !split_check:
        target_speed = max_speed
  if split_tracker:
    if split_tracker.position.z < 53 and split_check:
      target_speed = max_speed/6
    if split_tracker.position.z < 49.5 and split_check:
      target_offset = turn_offset
      target_speed = max_speed
      target_rotation = turn_rotation
      split_check = false
  position.x = lerp(position.x, target_offset, delta * current_speed * sin(posrad))
  rotation.y = lerp(rotation.y, target_rotation, delta * current_speed / 3.5)
  
  if chunks[0].position.z <= 0:
    chunk_count += 1
    var r = randi()
    var new_chunk
    if merge:
      new_chunk = CHUNK_MERGE.instantiate()
      merge = false
    elif is_jover or chunk_count == force_split_count:
      new_chunk = CHUNK_SPLIT.instantiate()
      split_tracker = new_chunk
      merge = true
      is_jover = false
    elif chunk_count == 2:
      new_chunk = CHUNK_MERGE.instantiate()
    elif r%3 == 0:
      new_chunk = CHUNK_1.instantiate()
    elif r%3 == 1:
      new_chunk = CHUNK_2.instantiate()
    elif r%3 == 2:
      new_chunk = CHUNK_3.instantiate()
    new_chunk.position.z += chunk_length * 2
    chunk_parent.add_child(new_chunk)
    var chunk_to_remove = chunks.pop_front()
    chunk_parent.remove_child(chunk_to_remove)
    chunks.append(new_chunk)


func on_acc_lever(state: bool):
  target_speed = max_speed if state else 0

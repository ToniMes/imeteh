extends Node3D
class_name ChunkMover

const CHUNK_1 = preload("res://Scenes/EnvironmentChunks/Chunk1.tscn")
const CHUNK_2 = preload("res://Scenes/EnvironmentChunks/Chunk2.tscn")
const CHUNK_3 = preload("res://Scenes/EnvironmentChunks/Chunk3.tscn")
const CHUNK_SPLIT = preload("res://Scenes/EnvironmentChunks/Chunk_split.tscn")
const CHUNK_MERGE = preload("res://Scenes/EnvironmentChunks/Chunk_merge.tscn")

@onready var chunk_parent: Node3D = $ChunkParent

var should_move: bool = false

var chunks: Array[Node3D]

var force_split_count = 1
var chunk_length: float = 49.5
var current_speed: float = 0
var target_speed: float = 0
var max_speed: float = 20
var chunk_count = 0

var is_jover = false
var merge = false
# A class that moves, loads in and loads out chunks of the world

func _ready():
  var chunk1 = CHUNK_1.instantiate()
  var chunk2 = CHUNK_2.instantiate()
  var chunk3 = CHUNK_2.instantiate()
  var chunk4 = CHUNK_2.instantiate()
  chunk1.position.z += chunk_length
  chunk2.position.z += chunk_length * 2
  chunk3.position.z += chunk_length * 3
  chunk4.position.z += chunk_length * 4
  chunks.append(chunk1)
  chunks.append(chunk2)
  chunks.append(chunk3)
  chunks.append(chunk4)
  chunk_parent.add_child(chunk1)
  chunk_parent.add_child(chunk2)
  chunk_parent.add_child(chunk3)
  chunk_parent.add_child(chunk4)
  Global.connectGlobalSignal(Global.acc_lever_switched, on_acc_lever)
  
func _process(delta: float) -> void:
  current_speed = lerp(current_speed, target_speed, delta)
  for chunk in chunks:
    chunk.position.z -= current_speed * delta
  
  #print_debug(chunks[0].position.z)
  
  if chunks[0].position.z <= 0:
    chunk_count += 1
    print_debug("Crossed the length of a chunk")
    var r = randi()
    var new_chunk
    if merge:
      new_chunk = CHUNK_MERGE.instantiate()
      merge = false
    elif is_jover or chunk_count == force_split_count:
      new_chunk = CHUNK_SPLIT.instantiate()
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
    new_chunk.position.z += chunk_length * 4
    chunk_parent.add_child(new_chunk)
    var chunk_to_remove = chunks.pop_front()
    chunk_parent.remove_child(chunk_to_remove)
    chunks.append(new_chunk)


func on_acc_lever(state: bool):
  target_speed = max_speed if state else 0

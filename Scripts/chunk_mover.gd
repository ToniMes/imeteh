extends Node3D
class_name ChunkMover

const CHUNK_1 = preload("res://Scenes/EnvironmentChunks/Chunk1.tscn")
const CHUNK_2 = preload("res://Scenes/EnvironmentChunks/Chunk2.tscn")
const CHUNK_3 = preload("res://Scenes/EnvironmentChunks/Chunk3.tscn")
const CHUNK_END = preload("res://Scenes/EnvironmentChunks/Chunk_end.tscn")

@onready var chunk_parent: Node3D = $ChunkParent

var should_move: bool = false

var chunks: Array[Node3D]

var chunk_length: int = 50
var current_speed: float = 0
var target_speed: float = 0
var max_speed: float = 5
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
    print_debug("Crossed the length of a chunk")
    var r = randi()
    var new_chunk
    if r%3 == 0:
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

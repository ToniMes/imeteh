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
var movement_speed: int = 5
var distance_crossed: int = 0
var total_distance_crossed: int = 0
# A class that moves, loads in and loads out chunks of the world

func _ready():
  var chunk1 = CHUNK_1.instantiate()
  var chunk2 = CHUNK_2.instantiate()
  chunk1.position.z += chunk_length
  chunk2.position.z += chunk_length * 2
  chunks.append(chunk1)
  chunks.append(chunk2)
  chunk_parent.add_child(chunk1)
  chunk_parent.add_child(chunk2)
  
  distance_crossed = 0
  total_distance_crossed = 0
  
func _process(delta: float) -> void:
  if !should_move:
    return
  
  for chunk in chunks:
    chunk.position.z -= movement_speed * delta
  
  print_debug(chunks[0].position.z)
  
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
    new_chunk.position.z += chunk_length * 2
    chunk_parent.add_child(new_chunk)
    distance_crossed = 0
    var chunk_to_remove = chunks.pop_front()
    chunk_parent.remove_child(chunk_to_remove)
    chunks.append(new_chunk)

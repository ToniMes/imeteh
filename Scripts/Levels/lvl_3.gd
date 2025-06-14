extends Node3D

@onready var trolley:Trolley  = $Trolley
@onready var trolley_body:MeshInstance3D  = trolley.get_node("TrolleyBody")
@onready var maze:Maze = trolley_body.get_node("Maze")

func _ready() -> void:
  Global.current_level = 3
  
  # Adding chunk mover to the scene
  var chunkMover:ChunkMover = load("res://Scenes/EnvironmentChunks/ChunkMover.tscn").instantiate()
  chunkMover.force_split_count = 12
  add_child(chunkMover)
  
  # Connecting signals
  Global.lever_switched.connect(_on_lever_switched)
  Global.finished_maze.connect(_on_finished_maze)
  Global.trolley_acceleration_changed.emit(1)
  Global.trolley_direction_changed.emit(Global.TrolleyDirection.LEFT)


func _on_lever_switched(name: String, direction: Global.LeverDirectionEnum) -> void:
  if name == "HorizontalDirectionLever":
    if direction == Global.LeverDirectionEnum.LEFT:
      maze.left()
    else:
      maze.right()
  elif name == "VerticalDirectionLever":
    if direction == Global.LeverDirectionEnum.RIGHT:
      maze.down()
    else:
      maze.up()


func _on_finished_maze() -> void:
  Global.trolley_direction_changed.emit(Global.TrolleyDirection.RIGHT)

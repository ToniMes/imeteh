extends Node3D

@onready var trolley:Trolley  = $Trolley
@onready var trolley_body:MeshInstance3D  = trolley.get_node("TrolleyBody")
@onready var maze:Maze = trolley_body.get_node("Maze")

func _ready() -> void:
  Global.current_level = 3
  Global.lever_switched.connect(_on_lever_switched)
  Global.trolley_acceleration_changed.emit(1)


func _on_lever_switched(name: String, state: bool) -> void:
  if name == "HorizontalDirectionLever":
    if state == false:
      maze.left()
    else:
      maze.right()
  elif name == "VerticalDirectionLever":
    if state == false:
      maze.down()
    else:
      maze.up()

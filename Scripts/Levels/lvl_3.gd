extends Node3D

@onready var trolley:Trolley  = $Trolley
@onready var trolley_body:MeshInstance3D  = trolley.get_node("TrolleyBody")
@onready var maze:Maze = trolley_body.get_node("Maze")

func _ready() -> void:
  Global.current_level = 3
  
  # Adding chunk mover to the scene
  var chunkMover:ChunkMover = load("res://Scenes/EnvironmentChunks/ChunkMover.tscn").instantiate()
  chunkMover.force_split_count = 20
  chunkMover.prepare_victims(["theseus"])
  add_child(chunkMover)
  
  # Connecting signals
  Global.lever_switched.connect(_on_lever_switched)
  Global.finished_maze.connect(_on_finished_maze)
  Global.trolley_track_changed.connect(_on_trolley_track_changed)
  Global.trolley_acceleration_changed.emit(1)
  Global.trolley_direction_changed.emit(Global.TrolleyDirection.LEFT)
  
  # Timers
  Audio.narrator.play_voiceline("3_1") # Lvl 3 1 - There is a maze that you should solve
  var secondVoiceTimer:Timer = Timer.new()
  secondVoiceTimer.one_shot = true
  secondVoiceTimer.wait_time = 20
  secondVoiceTimer.timeout.connect(func(): 
    if !maze.finished_maze:
      Audio.narrator.play_voiceline("3_2"))
  add_child(secondVoiceTimer)
  secondVoiceTimer.start()


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
  Audio.narrator.play_voiceline("3_4") # Lvl 3 4 - Huzzah, you solved the maze
  Global.trolley_direction_changed.emit(Global.TrolleyDirection.RIGHT)


func _on_trolley_track_changed(direction: Global.TrolleyDirection) -> void:
  var endVoiceTimer:Timer = Timer.new()
  endVoiceTimer.one_shot = true
  endVoiceTimer.wait_time = 5
  endVoiceTimer.timeout.connect(func(): 
    if direction == Global.TrolleyDirection.RIGHT:
      Audio.narrator.play_voiceline("3_5a") # Lvl 3 5a - See, you turned right and saved Thesius
    else:
      Audio.narrator.play_voiceline("3_5b") # Lvl 3 5b - Ooh, that was quite ugly
  )
  add_child(endVoiceTimer)
  endVoiceTimer.start()

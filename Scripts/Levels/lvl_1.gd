extends Node3D

var lever_switched_count:int = 0
@onready var trolley:Trolley = $Trolley
@onready var turnLeverButton:ClickableButton = $Trolley/TrolleyBody/TurnLeverButton
@onready var turnLever:StaticLever = $Trolley/TrolleyBody/TurnLever
@onready var accLever:StaticLever = $Trolley/TrolleyBody/AccLever
var cabinet_opened = false
var left_counter = 0
var right_counter = 0

func _ready() -> void:
    Audio.narrator.play_voiceline("1_1") # Lvl11-FiddleWithTheLever
    
    # Disabling button until cabinet doors are opened
    turnLeverButton.enabled = false
    
    # Connecting all the signals
    Global.lever_switched.connect(_on_lever_switched)
    Global.button_pressed.connect(_on_button_pressed)
    Global.cabinet_door_state_changed.connect(_on_cabinet_door_state_changed)
    Global.trolley_direction_changed.connect(_on_trolley_direction_changed)
    
    # Initializing levers
    turnLever.interactiveLever.enabled = false
    turnLever.interactiveLever.snap(Global.LeverDirectionEnum.LEFT)
    accLever.interactiveLever.snap(Global.LeverDirectionEnum.RIGHT)
    
    # Adding chunk mover to the scene
    var chunkMover:ChunkMover = load("res://Scenes/EnvironmentChunks/ChunkMover.tscn").instantiate()
    chunkMover.force_split_count = 20
    add_child(chunkMover)
    

func play_speeding_up():
    if lever_switched_count == 1:
        Audio.narrator.play_voiceline("1_2") # Lvl12-NowWe’reSpeedingUp


func play_slow_down():
    if lever_switched_count == 1:
        Audio.narrator.play_voiceline("1_3") # Lvl13-Okay,NowTrySlowingDown


func _on_lever_switched(name: String, direction: Global.LeverDirectionEnum):
  if name != "AccLever":
    return

  Global.trolley_acceleration_changed.emit(1)
  lever_switched_count += 1
  if lever_switched_count == 1:
    var timer12:Timer = Timer.new()
    timer12.one_shot = true
    timer12.wait_time = 1
    timer12.timeout.connect(func(): play_speeding_up())
    add_child(timer12)
    timer12.start()
    var timer13:Timer = Timer.new()
    timer13.one_shot = true
    timer13.wait_time = 7
    timer13.timeout.connect(func(): play_slow_down())
    add_child(timer13)
    timer13.start()
  elif lever_switched_count == 2:
    Audio.narrator.play_voiceline("1_4") # Lvl14-You’reSupposedToBeSlowingDown
    Audio.sfxPlayer.play_sound("sfx/broken_breaks.mp3", true)


func _on_button_pressed(name: String) -> void:
  if name == "TurnLeverButton":
    trolley.prepareTurnLever()


func _on_cabinet_door_state_changed(state: Global.DoorState):
  if state == Global.DoorState.OPEN and cabinet_opened == false:
    Audio.narrator.play_voiceline("1_7") # Lvl17-YouFiguredOutTheCabinetDoor
    cabinet_opened = true
    turnLeverButton.enabled = true


func _on_trolley_direction_changed(direction: Global.TrolleyDirection):
  # Updating turn counters
  if direction == Global.TrolleyDirection.LEFT:
    left_counter += 1
  elif direction == Global.TrolleyDirection.RIGHT:
    right_counter += 1
  
  # If this is the first time user switched turn lever
  if right_counter == 1 and direction == Global.TrolleyDirection.RIGHT:
    Audio.narrator.play_voiceline("1_8") # Lvl18-You’veFoundAWayToTurn
  
  # If this is the first time user manually turned lever left
  elif left_counter == 2 and direction == Global.TrolleyDirection.LEFT:
    Audio.narrator.play_voiceline("1_8a") # Lvl18a-NowThisIsInteresting,You’reStillGoingLeft…Hmm…

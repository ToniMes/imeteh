extends Node3D

var lever_switched_count:int = 0
@onready var trolley:Trolley = $Trolley
@onready var turnLeverButton:ClickableButton = $Trolley/TrolleyBody/TurnLeverButton
@onready var turnLever:StaticLever = $Trolley/TrolleyBody/TurnLever
@onready var accLever:StaticLever = $Trolley/TrolleyBody/AccLever

func _ready() -> void:
    Audio.narrator.play_voiceline("1_1") # Lvl11-FiddleWithTheLever
    
    # Connecting all the signals
    Global.lever_switched.connect(_on_lever_switched)
    Global.cabinet_door_state_changed.connect(_on_cabinet_door_state_changed)
    Global.trolley_direction_changed.connect(_on_trolley_direction_changed)
    turnLeverButton.connect("buttonPressed", trolley.prepareTurnLever)
    
    # Initializing levers
    turnLever.interactiveLever.enabled = false
    turnLever.interactiveLever.snap(Global.LeverDirectionEnum.LEFT)
    accLever.interactiveLever.snap(Global.LeverDirectionEnum.RIGHT)
    
    # Adding chunk mover to the scene
    var chunkMover:ChunkMover = load("res://Scenes/EnvironmentChunks/ChunkMover.tscn").instantiate()
    chunkMover.force_split_count = 12
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

func _on_button_pressed(name: String) -> void:
  if name == "TurnLeverButton":
    Global.trolley_direction_changed.emit(turnLever.state)

var firstOpen = true
func _on_cabinet_door_state_changed(state: Global.DoorState):
  if state == Global.DoorState.OPEN and firstOpen:
    Audio.narrator.play_voiceline("1_7") # Lvl17-YouFiguredOutTheCabinetDoor
    firstOpen = false

var firstTurn = true
func _on_trolley_direction_changed(direction: Global.TrolleyDirection):
  if firstTurn:
    Audio.narrator.play_voiceline("1_8") # Lvl18-You’veFoundAWayToTurn
    firstTurn = false
  elif firstTurn == false and direction == Global.TrolleyDirection.LEFT:
    Audio.narrator.play_voiceline("1_8a") # Lvl18a-NowThisIsInteresting,You’reStillGoingLeft…Hmm…

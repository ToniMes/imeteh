extends Node3D

var lever_switched_count:int = 0

func _ready() -> void:
    Audio.narrator.play_voiceline("1_1") # Lvl11-FiddleWithTheLever
    Global.acc_lever_switched.connect(_on_acc_lever_switched)
    Global.cabinet_door_state_changed.connect(_on_cabinet_door_state_changed)
    Global.trolley_direction_changed.connect(_on_trolley_direction_changed)

func _on_acc_lever_switched(state: bool):
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

func play_speeding_up():
    print("speeding up")
    if lever_switched_count == 1:
        Audio.narrator.play_voiceline("1_2") # Lvl12-NowWe’reSpeedingUp

func play_slow_down():
    if lever_switched_count == 1:
        Audio.narrator.play_voiceline("1_3") # Lvl13-Okay,NowTrySlowingDown

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

extends Node3D

@onready var trolley:Trolley = $Trolley
@onready var nail_board:NailBoard = $Trolley/NailBoard
@onready var trolley_body:MeshInstance3D  = trolley.get_node("TrolleyBody")
@onready var turn_lever:StaticLever  = trolley_body.get_node("TurnLever")
@onready var acc_lever:StaticLever  = trolley_body.get_node("AccLever")
@onready var player:PlayerController = trolley_body.get_node("Player")
var acc_lever_switch_counter = 0
var turn_lever_switch_counter = 0
var button_press_counter = 0

func _ready() -> void:
  Global.current_level = 2
  
  # Connecting signals
  Global.connectGlobalSignal(Global.lever_switched, _on_lever_switched)
  Global.button_pressed.connect(_on_button_pressed)
  Global.nail_nailed.connect(_on_nail_nailed)
  
  # Initializing levers
  turn_lever.interactiveLever.enabled = false
  turn_lever.interactiveLever.snap(Global.LeverDirectionEnum.LEFT)
  acc_lever.interactiveLever.snap(Global.LeverDirectionEnum.RIGHT)

  # Adding chunk mover to the scene
  var chunkMover:ChunkMover = load("res://Scenes/EnvironmentChunks/ChunkMover.tscn").instantiate()
  chunkMover.force_split_count = 20
  chunkMover.prepare_victims(["kittens"])
  add_child(chunkMover)
  
  Audio.narrator.play_voiceline("2_1") # Lvl 2 1 - Intro

func _on_button_pressed(name: String) -> void:
  button_press_counter += 1
  
  # Playing audio on first button press
  if button_press_counter == 1:
    Audio.narrator.play_voiceline("2_7") # Lvl 2 7 - Hmm.. It seems that when you press those little buttons…
  
  # Popping out the nail when a button is pressed
  if name == "LeftNailButton":
    nail_board.pop_up(0)
  if name == "MiddleNailButton":
    nail_board.pop_up(1)
  if name == "RightNailButton":
    nail_board.pop_up(2)

func play_please_slow_down() -> void:
  # only playing if user didn't break exactly once
  if acc_lever_switch_counter < 2:
    Audio.narrator.play_voiceline("2_2a") # Lvl 2 2a - (player did not listen) Please, slow us down now

func play_give_juice() -> void:
  # only playing if user broke only once
  if acc_lever_switch_counter == 2:
    Audio.narrator.play_voiceline("2_4") # Lvl 2 4 - Please, give this puppy some juice

func _on_lever_switched(name: String, direction: Global.LeverDirectionEnum) -> void:
  if name == "TurnLever":
    turn_lever_switch_counter += 1
    if direction == Global.LeverDirectionEnum.RIGHT and turn_lever_switch_counter == 1:
      Audio.narrator.play_voiceline("2_8") # Lvl 2 8 - Ah! A way to turn! That’s good.
    elif direction == Global.LeverDirectionEnum.LEFT and turn_lever_switch_counter == 2:
      Audio.narrator.play_voiceline("2_8a") # Lvl 2 8a - Just making sure you’re aware that you’re still headed to the left, right_
      
  elif name == "AccLever":
    Global.trolley_acceleration_changed.emit(1 if direction == Global.LeverDirectionEnum.LEFT else 0)
    acc_lever_switch_counter += 1
    
    if acc_lever_switch_counter == 1:
      Audio.narrator.play_voiceline("2_2") # Lvl 2 2 - Okay, now we are speeding up, now please, slow us down
      var slowDownTimer:Timer = Timer.new()
      slowDownTimer.one_shot = true
      slowDownTimer.wait_time = 10
      slowDownTimer.timeout.connect(func(): play_please_slow_down())
      add_child(slowDownTimer)
      slowDownTimer.start()
    
    if acc_lever_switch_counter == 2:
      Audio.narrator.play_voiceline("2_3") # Lvl 2 3 - See, we slowed down
      var giveJuiceTimer:Timer = Timer.new()
      giveJuiceTimer.one_shot = true
      giveJuiceTimer.wait_time = 20
      giveJuiceTimer.timeout.connect(func(): play_give_juice())
      add_child(giveJuiceTimer)
      giveJuiceTimer.start()
    
    # breaking the lever if this this is the third lever switch
    if acc_lever_switch_counter == 3:
      var throwable_lever:ThrowableLever = load("res://Scenes/Trolleys/Trolley components/throwable_lever.tscn").instantiate()
      throwable_lever.disable_grab_points()
      var lever = throwable_lever.get_node("Lever")
      add_child(throwable_lever)
    
      # making closest hand grab the lever
      var left_distance = acc_lever.global_position.distance_to(player.left_hand.global_position)
      var right_distance = acc_lever.global_position.distance_to(player.right_hand.global_position)
      trolley_body.remove_child(acc_lever)
      if left_distance < right_distance:
        player.left_pickup._pick_up_object(lever)
      else:
        player.right_pickup._pick_up_object(lever)
        
      Audio.narrator.play_voiceline("2_5") # Lvl 2 5 - Well that wasn’t supposed to happen


func _on_nail_nailed(nailed_count: int, total_nail_count: int):
  if nailed_count == total_nail_count:
    trolley.prepareTurnLever()

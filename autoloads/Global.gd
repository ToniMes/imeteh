extends Node

signal lever_switched(name: String, direction: LeverDirectionEnum)
signal button_pressed(name: String)
signal trolley_direction_changed(direction: TrolleyDirection)
signal trolley_acceleration_changed(accelration: int)
signal cabinet_door_state_changed(state: DoorState)
signal finished_maze
signal trolley_track_changed(direction: TrolleyDirection)
enum TrolleyDirection { LEFT, NONE, RIGHT }
enum LeverDirectionEnum { LEFT, NONE, RIGHT }
enum DoorState { OPEN, CLOSED }
var current_level: int = 0
var endVoiceTimer:Timer = Timer.new()


func _ready() -> void:
  trolley_track_changed.connect(_on_trolley_track_changed)
  endVoiceTimer.one_shot = true
  endVoiceTimer.wait_time = 5
  add_child(endVoiceTimer)


func connectGlobalSignal(sig: Signal, c: Callable):
  connect(sig.get_name(), c)


func start_next_level():
  Audio.sfxPlayer.stop_all()
  Audio.musicPlayer.stop_all()
  Audio.narrator.stop_narrator()
  current_level += 1
  start_level(current_level)
   
   
func start_level(level: int = current_level):
  current_level = level
  var level_scene = "res://Scenes/Levels/lvl" + str(current_level) + ".tscn"
  TransitionManager.switch_to_level(level_scene)
  

func _on_trolley_track_changed(direction: TrolleyDirection) -> void:
  var voiceline = ""
  if direction == Global.TrolleyDirection.LEFT:
    match current_level:
      1:
        voiceline = "2_9a"
      2:
        voiceline = "1_9b"
  elif direction == Global.TrolleyDirection.RIGHT:
    match current_level:
      1:
        voiceline = "1_9b"
      2:
        voiceline = "2_9a"
    
  endVoiceTimer.stop()
  endVoiceTimer.timeout.connect(func(): Audio.narrator.play_voiceline(voiceline))
  endVoiceTimer.start()

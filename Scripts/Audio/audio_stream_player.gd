extends AudioStreamPlayer

signal play_sound(sfx)
const AudioEnum = preload("res://Scripts/Audio/audio_enum.gd").AudioEnum

const MAX_PLAYERS = 24
var stream_players: Array[AudioStreamPlayer] = []

func _init() -> void:
  # Adding a certain amount of stream players that will be used to play sound
  for i in range(MAX_PLAYERS):
    var streamPlayer = AudioStreamPlayer.new()
    stream_players.append(streamPlayer)
    add_child(streamPlayer)

func _on_play_sound(audio: AudioEnum, loop: bool = false) -> void:
  # Not playing the sound if no stream players are available
  if stream_players.is_empty():
    printerr("Can't play sound, not enough stream players free!")
    return
    
  # Reserving a stream player
  var stream_player = stream_players.pop_front()
  var audio_value = AudioEnum.keys()[audio];
  stream_player.stream = load("res://Resources/Audio/" + audio_value + ".mp3")
  
  # Looping if loop=true, freeing up stream_player otherwise
  if loop:
    stream_player.finished.connect(_on_loop_sound.bind(stream_player))
  else:
    stream_player.finished.connect(func():_on_sound_finished(stream_player), CONNECT_ONE_SHOT)
  
  # Playing the sound effect
  print("playing sound " + audio_value)
  stream_player.play()

func _on_loop_sound(stream_player: AudioStreamPlayer):
  stream_player.play()

func _on_sound_finished(stream_player: AudioStreamPlayer):
  stream_players.append(stream_player)

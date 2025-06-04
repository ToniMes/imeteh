extends AudioStreamPlayer
class_name AudioControllerComponent

var stream_players: Array[AudioStreamPlayer] = []

func _init() -> void:
  # Adding a certain amount of stream players that will be used to play sound
  for i in range(self.max_polyphony):
    var streamPlayer = AudioStreamPlayer.new()
    streamPlayer.bus = bus
    stream_players.append(streamPlayer)
    add_child(streamPlayer)

func play_sound(audioPath: String, loop: bool = false, freeUpPlayer: bool = true) -> void:
  if stream_players.is_empty():
    # Not playing the sound if no stream players are available
    if freeUpPlayer == false:
      printerr("Can't play sound, not enough stream players free!")
      return
	# Freeing up a stream player by pausing the first child (oldest player) and then appending it to the back
    else:
      var first_child: AudioStreamPlayer = self.get_child(0)
      first_child.stop()
      self.remove_child(first_child)
      self.add_child(first_child)
      stream_players.push_front(first_child)

    
  # Reserving a stream player
  var resource_path = "res://Resources/Audio/" + audioPath
  if ResourceLoader.exists(resource_path) == false:
    print("Resource path " + resource_path + " does not exist!")
    return
  var stream_player = stream_players.pop_front()
  stream_player.stream = load(resource_path)
  
  # Looping if loop=true, freeing up stream_player otherwise
  if loop:
    stream_player.finished.connect(_on_loop_sound.bind(stream_player))
  else:
    stream_player.finished.connect(func():_on_sound_finished(stream_player), CONNECT_ONE_SHOT)
  
  # Playing the sound effect
  print("playing sound " + audioPath)
  stream_player.play()

func _on_loop_sound(stream_player: AudioStreamPlayer):
  stream_player.play()

func _on_sound_finished(stream_player: AudioStreamPlayer):
  stream_players.append(stream_player)

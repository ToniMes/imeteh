extends AudioStreamPlayer

func playLine(line: String):
  stream = load("res://Resources/Audio/Narator lines/" + line + ".mp3")
  play()

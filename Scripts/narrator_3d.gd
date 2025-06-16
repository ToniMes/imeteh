extends Node3D

@onready var narrator_panel: XRToolsViewport2DIn3D = $NarratorPanel

func play_voiceline(vl_name):
  Global.should_play_voiceline.emit(vl_name)
  
func stop_narrator():
  Global.should_stop_narrator.emit()

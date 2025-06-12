extends Control

@onready var play: Button = $ColorRect/VBoxContainer/VBoxContainer/Play
@onready var settings: Button = $ColorRect/VBoxContainer/VBoxContainer/Settings
@onready var exit: Button = $ColorRect/VBoxContainer/VBoxContainer/Exit

const SETTINGS_MENU_UI_PATH = "res://Scenes/UI/settings_menu_ui.tscn"

func _ready():
  play.pressed.connect(switch_to_gameplay)
  settings.pressed.connect(switch_to_settings_menu)
  
func switch_to_gameplay():
  Global.start_level(1)
  
func switch_to_settings_menu():
  var main_menu_panel: XRToolsViewport2DIn3D
  main_menu_panel = get_tree().get_first_node_in_group("MainMenuPanel")
  var SETTINGS_MENU_UI = load(SETTINGS_MENU_UI_PATH)
  main_menu_panel.scene = SETTINGS_MENU_UI

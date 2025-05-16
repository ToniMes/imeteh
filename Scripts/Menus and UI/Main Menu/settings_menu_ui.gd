extends Control

# These are for later adding actual functionalitye
@onready var back: Button = $ColorRect/VBoxContainer/VBoxContainer/Back
@onready var master_slider: HSlider = $ColorRect/VBoxContainer/VBoxContainer/SoundSettings/Master/HSlider
@onready var sfx_slider: HSlider = $ColorRect/VBoxContainer/VBoxContainer/SoundSettings/SFX/HSlider
@onready var voice_slider: HSlider = $ColorRect/VBoxContainer/VBoxContainer/SoundSettings/Voice/HSlider
@onready var show_cc_check_box: CheckBox = $ColorRect/VBoxContainer/VBoxContainer/Accesibility/DisplayCC/CheckBox
@onready var tunneling_check_box: CheckBox = $ColorRect/VBoxContainer/VBoxContainer/Accesibility/Tunneling/CheckBox

const MAIN_MENU_UI_PATH = "res://Scenes/UI/main_menu_ui.tscn"

func _ready():
	back.pressed.connect(switch_to_main_menu)

func switch_to_main_menu():
	var main_menu_panel: XRToolsViewport2DIn3D
	main_menu_panel = get_tree().get_first_node_in_group("MainMenuPanel")
	var MAIN_MENU_UI = load(MAIN_MENU_UI_PATH)
	main_menu_panel.scene = MAIN_MENU_UI

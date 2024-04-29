extends Control
class_name GameUIInput

@onready var game_manager : GameManager = $"/root/Game"
@onready var left_button : TouchScreenButton = $BottomLeftContainer/LeftButton
@onready var right_button : TouchScreenButton = $BottomLeftContainer/RightButton
@onready var jump_button : TouchScreenButton = $BottomRightContainer/JumpButton

func _ready() -> void:
	register_signal_callbacks()
	visible = DisplayServer.is_touchscreen_available()

func register_signal_callbacks() -> void:
	game_manager.on_paused.connect(on_paused.bind())
	left_button.set_action("ui_left")
	right_button.set_action("ui_right")
	jump_button.set_action("ui_select")

func on_paused(is_paused:bool) -> void:
	left_button.visible = !is_paused
	right_button.visible = !is_paused
	jump_button.visible = !is_paused

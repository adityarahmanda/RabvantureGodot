extends Control
class_name GameUIInput

@onready var left_input_button : TouchScreenButton = %LeftInputButton
@onready var right_input_button : TouchScreenButton = %RightInputButton
@onready var jump_input_button : TouchScreenButton = %JumpInputButton

func _ready():
	if OS.get_name() == "Android":
		left_input_button.set_action("ui_left")
		right_input_button.set_action("ui_right")
		jump_input_button.set_action("ui_select")
		left_input_button.visible = true
		right_input_button.visible = true
		jump_input_button.visible = true
	else:
		left_input_button.visible = false
		right_input_button.visible = false
		jump_input_button.visible = false

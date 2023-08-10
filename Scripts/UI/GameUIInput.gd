extends Control

@onready var left_input_button : TouchScreenButton = %LeftInputButton
@onready var right_input_button : TouchScreenButton = %RightInputButton
@onready var jump_input_button : TouchScreenButton = %JumpInputButton

func _ready():
	left_input_button.set_action("ui_left")
	right_input_button.set_action("ui_right")
	jump_input_button.set_action("ui_select")

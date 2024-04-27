extends Control
class_name GameUIInput

func _ready():
	visible = DisplayServer.is_touchscreen_available()

func _on_left_input_button_button_down():
	Input.action_press("ui_left")

func _on_left_input_button_button_up():
	Input.action_release("ui_left")

func _on_right_input_button_button_down():
	Input.action_press("ui_right")

func _on_right_input_button_button_up():
	Input.action_release("ui_right")

func _on_jump_input_button_button_down():
	Input.action_press("ui_select")

func _on_jump_input_button_button_up():
	Input.action_release("ui_select")

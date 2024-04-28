extends Node
class_name UISelector

@export var left_button : TextureButton
@export var right_button : TextureButton
@export var selected_item_label : Label
@export var selection_list : Array = []

var selected_item : String
var selected_index : int = 0

func _ready():
	_on_initialize_label()
	register_signal_callbacks()

func register_signal_callbacks() -> void:
	left_button.button_up.connect(_on_left_button_pressed.bind())
	right_button.button_up.connect(_on_right_button_pressed.bind())

func _on_initialize_label() -> void:
	refresh_label()

func refresh_label() -> void:
	selected_item = selection_list[selected_index] if selection_list.size() != 0 else selected_item_label.text
	_on_refresh_label()

func _on_refresh_label() -> void:
	selected_item_label.text = selected_item

func _on_right_button_pressed() -> void:
	selected_index += 1
	if (selected_index > selection_list.size() - 1):
		selected_index = 0
	refresh_label()

func _on_left_button_pressed() -> void:
	selected_index -= 1
	if (selected_index < 0):
		selected_index = selection_list.size() - 1
	refresh_label()

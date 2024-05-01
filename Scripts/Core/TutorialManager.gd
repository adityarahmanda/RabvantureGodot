extends Node2D
class_name TutorialManager

@onready var tutorial_label:RichTextLabel = %TutorialLabel

@export var left_input_image : Texture2D
@export var right_input_image : Texture2D
@export var jump_input_image : Texture2D
@export var space_input_image : Texture2D

var is_in_tutorial_area : bool = false
var is_show_move_tutorial : bool = false
var is_show_jump_tutorial : bool = false

func _ready():
	Localization.on_locale_changed.connect(on_player_entered_or_exited.bind())
	is_show_move_tutorial = true
	on_player_entered_or_exited()
	
func on_player_entered_or_exited():
	if (is_show_jump_tutorial):
		var image = jump_input_image if DisplayServer.is_touchscreen_available() else space_input_image
		set_tutorial_label_text(tr("jump_tutorial") % get_image_text(image))
	elif (is_show_move_tutorial):
		set_tutorial_label_text(tr("move_tutorial") % [get_image_text(left_input_image), get_image_text(right_input_image)])
	is_in_tutorial_area = is_show_jump_tutorial || is_show_move_tutorial
	
func get_image_text(image:Texture2D) -> String:
	if (image == null): return ""
	return "[img=8]" + image.resource_path + "[/img]"

func set_tutorial_label_text(text:String) -> void:
	text = "[center][font_size=%s]%s[/font_size][/center]" % [4, text]
	tutorial_label.text = text

func _on_move_tutorial_area_body_entered(body):
	if (!body.is_in_group("Player")): return
	is_show_move_tutorial = true
	on_player_entered_or_exited()

func _on_move_tutorial_area_body_exited(body):
	if (!body.is_in_group("Player")): return
	is_show_move_tutorial = false
	on_player_entered_or_exited()
	
func _on_jump_tutorial_area_body_entered(body):
	if (!body.is_in_group("Player")): return
	is_show_jump_tutorial = true
	on_player_entered_or_exited()

func _on_jump_tutorial_area_body_exited(body):
	if (!body.is_in_group("Player")): return
	is_show_jump_tutorial = false
	on_player_entered_or_exited()

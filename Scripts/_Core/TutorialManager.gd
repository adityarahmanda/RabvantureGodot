extends Node2D
class_name TutorialManager

@onready var tutorial_label:RichTextLabel = %TutorialLabel

@export var move_left_image:Texture2D
@export var move_right_image:Texture2D
@export var jump_image:Texture2D

var is_show_move_tutorial:bool = false
var is_show_jump_tutorial:bool = false

func _ready():
	is_show_move_tutorial = true
	on_player_entered_or_exited()
	
func on_player_entered_or_exited():
	if (is_show_jump_tutorial):
		set_tutorial_label_text("Hold and Release %s to Jump\nHold it longer to Jump Higher" % get_image_text(jump_image))
	elif (is_show_move_tutorial):
		set_tutorial_label_text("Press %s %s to Move" % [get_image_text(move_left_image), get_image_text(move_right_image)])
	
func get_image_text(image:Texture2D) -> String:
	if (image == null): return ""
	return "[img=8]" + image.resource_path + "[/img]"

func set_tutorial_label_text(text:String):
	text = "[center][font_size=4]" + text + "[/font_size][/center]"
	tutorial_label.text = text

func _on_move_tutorial_area_body_entered(body):
	if (body.name != "Player"): return
	is_show_move_tutorial = true
	on_player_entered_or_exited()

func _on_move_tutorial_area_body_exited(body):
	if (body.name != "Player"): return
	is_show_move_tutorial = false
	on_player_entered_or_exited()
	
func _on_jump_tutorial_area_body_entered(body):
	if (body.name != "Player"): return
	is_show_jump_tutorial = true
	on_player_entered_or_exited()

func _on_jump_tutorial_area_body_exited(body):
	if (body.name != "Player"): return
	is_show_jump_tutorial = false
	on_player_entered_or_exited()

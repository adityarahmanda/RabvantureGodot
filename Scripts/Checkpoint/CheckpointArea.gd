extends Node2D
class_name CheckpointArea

@onready var sprite : Sprite2D = $Sprite2D
@onready var checkpoint_label : RichTextLabel = %CheckpointLabel

@export var is_facing_right : bool = true

@export_group("Sprite Settings")
@export var active_frame_coords : Vector2
@export var inactive_frame_coords : Vector2

@export_group("Label Tween Settings")
@export var tween_duration : float
@export var stay_duration : float
@export var position_offset : Vector2 

var is_active : bool
var label_tween : Tween

signal on_enter_area(area : CheckpointArea)

func _ready():
	Localization.on_locale_changed.connect(refresh_ui.bind())
	refresh_ui()
	checkpoint_label.visible = false
	set_area_active(false)

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		on_enter_area.emit(self)

func refresh_ui() -> void:
	checkpoint_label.text = "[center][font_size=4]%s[/font_size][/center]" % tr("checkpoint")

func set_area_active(_is_active : bool) -> void:
	is_active = _is_active
	if (is_active):
		sprite.frame_coords = active_frame_coords
		AudioManager.play_sfx("checkpoint")
		play_checkpoint_label_tween()
	else:
		sprite.frame_coords = inactive_frame_coords

func play_checkpoint_label_tween() -> void:
	checkpoint_label.position = Vector2.ZERO
	if (label_tween != null):
		label_tween.kill()
	
	checkpoint_label.visible = true
	label_tween = create_tween()
	await label_tween.tween_property(checkpoint_label, "position", position_offset, tween_duration).finished
	await get_tree().create_timer(stay_duration).timeout
	checkpoint_label.visible = false

extends Node2D
class_name CheckpointManager

var checkpoint_areas : Array
var current_checkpoint_area : CheckpointArea

func _ready() -> void:
	checkpoint_areas = find_children("*", "CheckpointArea")
	for checkpoint_area in checkpoint_areas:
		checkpoint_area.on_enter_area.connect(on_enter_checkpoint_area.bind())

func on_enter_checkpoint_area(checkpoint_area : CheckpointArea) -> void:
	if (current_checkpoint_area == null):
		current_checkpoint_area = checkpoint_area
		current_checkpoint_area.set_area_active(true)
		return
		
	if (checkpoint_area.global_position.y < current_checkpoint_area.global_position.y):
		current_checkpoint_area.set_area_active(false)
		current_checkpoint_area = checkpoint_area
		current_checkpoint_area.set_area_active(true)

func has_checkpoint() -> bool:
	return current_checkpoint_area != null

func get_checkpoint() -> Vector2:
	return current_checkpoint_area.global_position if has_checkpoint() else Vector2.ZERO

func get_checkpoint_face_direction() -> bool:
	return current_checkpoint_area.is_facing_right

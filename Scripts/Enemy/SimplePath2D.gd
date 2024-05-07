extends Path2D
class_name SimplePath2D

var start_pos : Vector2
var end_pos : Vector2

func _ready() -> void:
	start_pos = curve.get_point_position(0) + global_position
	end_pos = curve.get_point_position(1) + global_position

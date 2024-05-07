class_name MainCamera
extends Camera2D

@export var followSpeed := 5

var follow_target : Node2D

func _process(delta) -> void:
	if (follow_target != null):
		global_position = lerp(global_position, follow_target.global_position, followSpeed * delta)

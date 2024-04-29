class_name MainCamera
extends Camera2D

@export var followSpeed := 5

var follow_target : Node2D

func _process(delta) -> void:
	if (follow_target != null):
		position = lerp(position, follow_target.position, followSpeed * delta)

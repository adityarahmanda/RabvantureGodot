extends Camera2D

@export var followTarget : Node2D
@export var speed = 5

func _process(delta):
	position = lerp(position, followTarget.position, speed * delta)

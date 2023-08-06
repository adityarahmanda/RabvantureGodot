extends Camera2D

@onready var player = $"../Player"
@export var speed = 5

func _process(delta):
	position = lerp(position, player.position, speed * delta)

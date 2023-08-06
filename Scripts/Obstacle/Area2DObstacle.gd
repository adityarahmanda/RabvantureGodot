extends Area2D
class_name ObstacleEntity

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.die()

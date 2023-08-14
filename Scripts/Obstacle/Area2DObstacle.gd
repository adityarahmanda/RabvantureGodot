extends Area2D
class_name ObstacleEntity

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.die(Global.DeathType.HIT)

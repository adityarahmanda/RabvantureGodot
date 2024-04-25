class_name EnemyEntity
extends Entity

@export var animator :  AnimationPlayer
@export var sprite_2d : Sprite2D
@export var is_facing_right := true
	
func on_physics_process(_delta) -> void:
	handle_facing()

func handle_facing() -> void:
	if is_facing_right:
		sprite_2d.scale.x = 1
	else:
		sprite_2d.scale.x = -1

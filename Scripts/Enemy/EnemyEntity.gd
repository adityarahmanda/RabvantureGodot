class_name EnemyEntity
extends Entity

@export var animator :  AnimationPlayer
@export var sprite_2d : Sprite2D

var is_facing_right := true
	
func _physics_process(_delta):
	handle_facing()

func handle_facing() -> void:
	if is_facing_right:
		sprite_2d.scale.x = 1
	else:
		sprite_2d.scale.x = -1

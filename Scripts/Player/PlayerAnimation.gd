extends AnimationPlayer

@export var player : PlayerEntity

var currentAnimation := "Idle"

func _process(_delta) -> void:
	if (player.is_dead): return
	handle_animation()
	
func handle_animation() -> void:
	if (player.is_on_floor()):
		if player.is_prepare_jump:
			currentAnimation = "PrepareJumpWalk" if player.direction else "PrepareJump"
		else:
			currentAnimation = "Walk" if player.direction else "Idle"
	else:
		currentAnimation = "Fall" if player.velocity.y > 0.0 else "Jump"
	
	print_debug(currentAnimation)
	play(currentAnimation)

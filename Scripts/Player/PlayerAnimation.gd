extends AnimationPlayer

@export var player : PlayerEntity

var currentAnimation := "Idle"

func _process(_delta) -> void:
	handle_animation()
	
func handle_animation() -> void:
	if player.is_charge_jumping and player.is_on_floor():
		currentAnimation = "ChargeJumpingWalk" if player.direction else "ChargeJumpingIdle"
	else:
		currentAnimation = "Walk" if player.direction else "Idle"
	
	play(currentAnimation)

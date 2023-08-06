extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const JUMP_FORGIVENESS = 0.2

var direction = 0.0
var isJumping = false
var elapsedJumpTime = 0.2
var ungroundedTime = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	handle_movement(delta)
	handle_facing(delta)
	handle_animation(delta)
	
func handle_movement(delta):
	direction = clamp(Input.get_axis("ui_left", "ui_right"), -1, 1)
	if Input.is_action_just_pressed("ui_accept"):
		elapsedJumpTime = 0
	else:
		elapsedJumpTime += delta
	
	# Handle Jump
	if is_on_floor():
		ungroundedTime = 0
		isJumping = false
	else:
		velocity.y += gravity * delta
		ungroundedTime += delta
	
	if elapsedJumpTime <= JUMP_FORGIVENESS and ungroundedTime <= JUMP_FORGIVENESS and !isJumping:
		velocity.y = JUMP_VELOCITY
		isJumping = true
		
	# Handle Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func handle_facing(delta):
	if direction > 0:
		$Sprite2D.scale.x = 1
	elif direction < 0:
		$Sprite2D.scale.x = -1

func handle_animation(delta):
	if direction:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")



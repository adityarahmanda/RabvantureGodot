extends CharacterBody2D

const SPEED = 100.0
const MIN_JUMP_VELOCITY = 150.0
const MAX_JUMP_VELOCITY = 300.0
const CHARGE_JUMP_TIME = 1.0
const JUMP_FORGIVENESS = 0.2

var direction = 0.0
var isJumping = false
var isChargeJumping = false
var elapsedChargeJumpTime = 0
var elapsedJumpTime = JUMP_FORGIVENESS
var jumpVelocity = 0
var ungroundedTime = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentAnimation = ""

func _physics_process(delta):
	handle_movement(delta)
	handle_facing()
	handle_animation()

func handle_movement(delta):
	# Handle Jump
	if Input.is_action_just_pressed("ui_accept"):
		elapsedChargeJumpTime = 0
		jumpVelocity = MIN_JUMP_VELOCITY
		isChargeJumping = true
	if Input.is_action_just_released("ui_accept"):
		isChargeJumping = false

	if isChargeJumping:
		jumpVelocity = lerp(jumpVelocity, MAX_JUMP_VELOCITY, elapsedChargeJumpTime / CHARGE_JUMP_TIME)
		jumpVelocity = clamp(jumpVelocity, MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY)
		elapsedChargeJumpTime += delta
		elapsedJumpTime = 0

	if is_on_floor():
		ungroundedTime = 0
		isJumping = false
	else:
		ungroundedTime += delta
		velocity.y += gravity * delta
		
	if ungroundedTime > JUMP_FORGIVENESS && !is_on_floor():
		jumpVelocity = MIN_JUMP_VELOCITY

	elapsedJumpTime += delta
	if elapsedJumpTime <= JUMP_FORGIVENESS and ungroundedTime <= JUMP_FORGIVENESS and !isJumping and !isChargeJumping:
		print(jumpVelocity)
		velocity.y = -jumpVelocity
		isJumping = true

	# Handle Movement
	direction = clamp(Input.get_axis("ui_left", "ui_right"), -1, 1)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func handle_facing():
	if direction > 0:
		$Sprite2D.scale.x = 1
	elif direction < 0:
		$Sprite2D.scale.x = -1

func handle_animation():
	if isChargeJumping and is_on_floor():
		currentAnimation = "ChargeJumpingWalk" if direction else "ChargeJumpingIdle"
	else:
		currentAnimation = "Walk" if direction else "Idle"
	
	$AnimationPlayer.play(currentAnimation)

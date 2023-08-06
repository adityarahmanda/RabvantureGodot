extends Entity
class_name PlayerEntity

@export var minJumpVelocity = 150.0
@export var maxJumpVelocity = 300.0
@export var chargeJumpTime = 1.0
@export var jumpForgiveness = 0.2

var direction = 0.0
var isJumping = false
var isChargeJumping = false
var elapsedChargeJumpTime = 0
var elapsedJumpTime = jumpForgiveness
var jumpVelocity = 0
var ungroundedTime = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentAnimation = ""

func _physics_process(delta):
	handle_movement(delta)
	handle_facing()

func handle_movement(delta):
	# Handle Jump
	if Input.is_action_just_pressed("ui_accept"):
		elapsedChargeJumpTime = 0
		jumpVelocity = minJumpVelocity
		isChargeJumping = true
	if Input.is_action_just_released("ui_accept"):
		isChargeJumping = false

	if isChargeJumping:
		jumpVelocity = lerp(jumpVelocity, maxJumpVelocity, elapsedChargeJumpTime / chargeJumpTime)
		jumpVelocity = clamp(jumpVelocity, minJumpVelocity, maxJumpVelocity)
		elapsedChargeJumpTime += delta
		elapsedJumpTime = 0

	if is_on_floor():
		ungroundedTime = 0
		isJumping = false
	else:
		ungroundedTime += delta
		velocity.y += gravity * delta
		
	if ungroundedTime > jumpForgiveness && !is_on_floor():
		jumpVelocity = minJumpVelocity

	elapsedJumpTime += delta
	if elapsedJumpTime <= jumpForgiveness and ungroundedTime <= jumpForgiveness and !isJumping and !isChargeJumping:
		velocity.y = -jumpVelocity
		isJumping = true

	# Handle Movement
	direction = clamp(Input.get_axis("ui_left", "ui_right"), -1, 1)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func handle_facing():
	if direction > 0:
		$Sprite2D.scale.x = 1
	elif direction < 0:
		$Sprite2D.scale.x = -1
		
func die():
	print("Die")

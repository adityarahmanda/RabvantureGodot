extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var isJumping = false
var jumpForgiveness = 0.2
var ungroundedTime = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if is_on_floor():
		ungroundedTime = 0
		isJumping = false
	else:
		velocity.y += gravity * delta
		ungroundedTime += delta
		
	if Input.is_action_just_pressed("ui_accept") and ungroundedTime <= jumpForgiveness and !isJumping:
		velocity.y = JUMP_VELOCITY
		isJumping = true

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		$Sprite2D.scale.x = 1
	elif direction < 0:
		$Sprite2D.scale.x = -1
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if isJumping:
		if velocity.y > 0:
			$AnimationPlayer.play("Jump_Up")
		elif velocity.y < 0:
			$AnimationPlayer.play("Jump_Down")
	else:
		if direction:
			$AnimationPlayer.play("Walk")
		else:
			$AnimationPlayer.play("Idle")

	move_and_slide()

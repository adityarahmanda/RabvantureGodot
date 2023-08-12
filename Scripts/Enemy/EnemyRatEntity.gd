class_name EnemyRatEntity
extends Entity

@onready var path_2d : Path2D = $Path2D
@onready var sprite_2d : Sprite2D = $Sprite2D

var init_pos : Vector2
var end_pos : Vector2
var is_facing_right := true

func _ready() -> void:
	init_pos = path_2d.curve.get_point_position(0) + position
	end_pos = path_2d.curve.get_point_position(1) + position
	
func _physics_process(delta):
	handle_movement(delta)
	handle_facing()
	handle_animation()
	
func handle_movement(_delta):
	if(position.x <= init_pos.x):
		velocity.x = speed
		is_facing_right = true
	elif (position.x >= end_pos.x):
		velocity.x = -speed
		is_facing_right = false
		
	move_and_slide()

func handle_facing() -> void:
	if is_facing_right:
		sprite_2d.scale.x = 1
	else:
		sprite_2d.scale.x = -1
	
func handle_animation() -> void:
	$AnimationPlayer.play("Walk")

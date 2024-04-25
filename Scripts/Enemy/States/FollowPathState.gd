extends State
class_name FollowPathState

@export var actor : EnemyEntity
@export var simple_path_2d : SimplePath2D
@export var follow_animation : String = "Walk"
@export var is_vertical : bool = false

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	handle_animation()

func _exit_state() -> void:
	set_physics_process(false)

func on_physics_process(_delta) -> void:
	if (is_vertical):
		if(actor.position.y <= simple_path_2d.end_pos.y):
			actor.velocity.y = actor.speed
		elif (actor.position.y >= simple_path_2d.start_pos.y):
			actor.velocity.y = -actor.speed
	else:
		if(actor.position.x <= simple_path_2d.start_pos.x):
			actor.velocity.x = actor.speed
			actor.is_facing_right = true
		elif (actor.position.x >= simple_path_2d.end_pos.x):
			actor.velocity.x = -actor.speed
			actor.is_facing_right = false
		
	actor.move_and_slide()
	
func handle_animation() -> void:
	actor.animator.play(follow_animation)

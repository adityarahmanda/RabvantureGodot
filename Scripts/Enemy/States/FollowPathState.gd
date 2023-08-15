extends State
class_name FollowPathState

@export var actor : EnemyEntity
@export var simple_path_2d : SimplePath2D
@export var follow_animation : String = "Walk"

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	handle_animation()

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta) -> void:
	if(actor.position.x <= simple_path_2d.start_pos.x):
		actor.velocity.x = actor.speed
		actor.is_facing_right = true
	elif (actor.position.x >= simple_path_2d.end_pos.x):
		actor.velocity.x = -actor.speed
		actor.is_facing_right = false
		
	actor.move_and_slide()
	
func handle_animation() -> void:
	actor.animator.play(follow_animation)

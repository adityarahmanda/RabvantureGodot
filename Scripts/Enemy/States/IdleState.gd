extends State
class_name IdleState

@export var actor : EnemyEntity
@export var idle_animation : String = "Idle"

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	handle_animation()

func _exit_state() -> void:
	set_physics_process(false)
	
func handle_animation() -> void:
	actor.animator.play(idle_animation)

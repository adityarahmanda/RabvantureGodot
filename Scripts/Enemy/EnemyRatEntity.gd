extends Entity
class_name EnemyRatEntity

func _ready():
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
	move_and_slide()

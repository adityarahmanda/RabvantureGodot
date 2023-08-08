class_name EnemyRatEntity
extends Entity

func _ready() -> void:
	$AnimationPlayer.play("Idle")

func _physics_process(_delta) -> void:
	move_and_slide()

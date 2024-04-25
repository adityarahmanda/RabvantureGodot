extends CharacterBody2D
class_name Entity

@onready var game_manager : GameManager = $"/root/Game"
@export var speed : float = 100.0

var is_dead : bool = false

func _physics_process(delta) -> void:
	if (game_manager.is_paused): return
	if (is_dead): return
	
	on_physics_process(delta)

func on_physics_process(_delta) -> void:
	pass

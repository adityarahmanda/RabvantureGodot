class_name State
extends Node

@onready var game_manager : GameManager = $"/root/Game"

signal state_finished

func _enter_state() -> void:
	pass

func _exit_state() -> void:
	pass
	
func _physics_process(delta) -> void:
	if (game_manager.is_paused): return
	on_physics_process(delta)
	
func on_physics_process(_delta) -> void:
	pass

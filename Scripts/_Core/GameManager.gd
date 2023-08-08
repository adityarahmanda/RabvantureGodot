extends Node2D

@onready var player : PlayerEntity = $Player
@onready var main_camera : GameCamera = $MainCamera

func _ready() -> void:
	SaveGame.load_json()
	register_signal_callbacks()
	main_camera.follow_target = player
	
func register_signal_callbacks() -> void:
	player.on_dead.connect(on_player_die.bind())

func on_player_die() -> void:
	Global.death_count += 1
	SaveGame.save_json()
	reset_game()

func reset_game() -> void:
	get_tree().reload_current_scene()
	

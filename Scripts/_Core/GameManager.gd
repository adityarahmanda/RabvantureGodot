extends Node2D
class_name GameManager

@onready var player : PlayerEntity = $Player
@onready var main_camera : GameCamera = %Services/MainCamera
@onready var main_canvas : GameUI = %Services/MainCanvas
@onready var audio_manager : AudioManager = %Services/AudioManager

func _ready() -> void:
	SaveGame.load_json()
	register_signal_callbacks()
	main_camera.follow_target = player
	main_canvas.refresh_ui()

func _process(_delta) -> void:
	handle_score()
	
func register_signal_callbacks() -> void:
	player.on_dead.connect(on_player_die.bind())

func on_player_die() -> void:
	Global.death_count += 1
	main_camera.follow_target = null
	main_canvas.refresh_ui()
	SaveGame.save_json()
	await get_tree().create_timer(Global.reset_scene_delay).timeout
	main_camera.follow_target = player
	player.respawn()
	
func handle_score() -> void:
	if (player == null): return
	Global.score = maxi(0, -player.position.y as int)
	main_canvas.set_score(Global.score)

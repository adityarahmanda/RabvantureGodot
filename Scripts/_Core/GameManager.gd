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
	await get_tree().create_timer(Global.reset_scene_delay).timeout
	Global.last_bgm_time = audio_manager.bgm_player.get_playback_position()
	Global.death_count += 1
	SaveGame.save_json()
	reset_game()
	
func handle_score() -> void:
	if (player == null): return
	
	Global.score = maxi(0, -player.position.y)
	main_canvas.set_score(Global.score)

func reset_game() -> void:
	get_tree().reload_current_scene()
	

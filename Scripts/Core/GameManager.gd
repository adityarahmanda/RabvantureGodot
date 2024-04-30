extends Node2D
class_name GameManager

@onready var main_camera : MainCamera = %Services/MainCamera
@onready var checkpoint_manager : CheckpointManager = %Services/CheckpointManager
@onready var main_canvas : MainCanvas = %Canvases/MainCanvas
@onready var pause_canvas : PauseCanvas = %Canvases/PauseCanvas
@onready var level_setup : LevelSetup = $LevelSetup

@export var respawn_delay : float = 1.0
@export var spawn_transform : Node2D
@export var player : PlayerEntity

var spawn_position : Vector2
var score : int = 0
var is_game_ends : bool = false
var is_paused : bool = false

signal on_paused(is_paused : bool)

func _ready() -> void:
	register_signal_callbacks()
	AudioManager.play_bgm()
	main_canvas.refresh_ui()
	main_canvas.show_pause_panel(is_paused)
	cache_spawn_position()
	set_player_at_spawn_position()
	start_game()

func _process(_delta) -> void:
	handle_score()
	handle_pause_input()
	
func register_signal_callbacks() -> void:
	player.on_dead.connect(on_player_die.bind())
	main_canvas.pause_button.button_up.connect(on_toggle_paused.bind())
	pause_canvas.return_button.button_up.connect(on_toggle_paused.bind())
	main_canvas.respawn_checkpoint_ad_loaded.connect(on_respawn_checkpoint_ad_loaded.bind())
	main_canvas.respawn_checkpoint_ad_failed.connect(on_respawn_checkpoint_ad_failed.bind())
	main_canvas.respawn_checkpoint_ad_rewarded.connect(on_respawn_checkpoint_ad_rewarded.bind())

func start_game() -> void:
	player.set_alive()
	main_camera.follow_target = player
	is_game_ends = false

func ends_game() -> void:
	main_camera.follow_target = null
	main_canvas.refresh_ui()
	if (!is_game_ends):
		FirebaseManager.log_game_ends("fail", score)
		is_game_ends = true
	set_player_at_spawn_position()
	SaveGame.save_json()
	await get_tree().create_timer(respawn_delay).timeout
	start_game()

func handle_pause_input() -> void:
	if Input.is_action_just_released("ui_cancel"):
		on_toggle_paused()

func on_toggle_paused() -> void:
	set_game_paused(!is_paused)

func set_game_paused(is_true:bool) -> void:
	main_canvas.show_pause_panel(is_true)
	is_paused = is_true
	on_paused.emit(is_true)

func on_player_die() -> void:
	Global.death_count += 1
	FirebaseManager.log_death(Global.death_count)
	ends_game()
	
func handle_score() -> void:
	if (player == null): return
	score = maxi(0, -player.position.y as int)
	main_canvas.set_score(score)
	if (!is_game_ends and score >= level_setup.top_y_level):
		FirebaseManager.log_game_ends("complete", score)
		is_game_ends = true

func cache_spawn_position() -> void:
	if (spawn_transform == null):
		spawn_position = player.global_position
	else:
		spawn_position = spawn_transform.global_position

func set_player_at_spawn_position() -> void:
	if(checkpoint_manager.has_checkpoint()):
		player.global_position = checkpoint_manager.get_checkpoint()
	else:
		player.global_position = spawn_position

func on_respawn_checkpoint_ad_loaded() -> void:
	pass
	
func on_respawn_checkpoint_ad_failed() -> void:
	pass
	
func on_respawn_checkpoint_ad_rewarded() -> void:
	start_game()

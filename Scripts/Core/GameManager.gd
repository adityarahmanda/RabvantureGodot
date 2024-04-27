extends Node2D
class_name GameManager

@onready var player : PlayerEntity = $Player
@onready var main_camera : GameCamera = %Services/MainCamera
@onready var main_canvas : GameUI = %Services/MainCanvas
@onready var audio_manager : AudioManager = %Services/AudioManager
@onready var level_setup : LevelSetup = %Services/LevelSetup
@onready var game_analytics_manager : GameAnalyticsManager = %Services/GameAnalyticsManager

@export var reset_scene_delay : float = 1.0

var score : int = 0
var is_game_ends : bool = false
var is_paused : bool = false

signal on_paused(is_paused : bool)

func _ready() -> void:
	main_canvas.refresh_ui()
	main_canvas.show_pause_panel(is_paused)
	register_signal_callbacks()
	initialize_locale()
	start_game()

func _process(_delta) -> void:
	handle_score()
	handle_pause_input()
	
func register_signal_callbacks() -> void:
	player.on_dead.connect(on_player_die.bind())
	main_canvas.connect_pause_button(on_toggle_paused.bind())

func initialize_locale() -> void:
	var locale = Global.locale if Global.locale != "" else OS.get_locale()
	Localization.set_locale(locale)

func start_game() -> void:
	game_analytics_manager.log_game_start()
	main_camera.follow_target = player
	player.respawn()
	is_game_ends = false

func ends_game() -> void:
	main_camera.follow_target = null
	main_canvas.refresh_ui()
	if (!is_game_ends):
		game_analytics_manager.log_game_ends("Fail", score)
		is_game_ends = true
	SaveGame.save_json()
	await get_tree().create_timer(reset_scene_delay).timeout
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
	game_analytics_manager.log_death_count(Global.death_count)
	ends_game()
	
func handle_score() -> void:
	if (player == null): return
	score = maxi(0, -player.position.y as int)
	main_canvas.set_score(score)
	if (!is_game_ends and score >= level_setup.top_y_level):
		game_analytics_manager.log_game_ends("Complete", score)
		is_game_ends = true

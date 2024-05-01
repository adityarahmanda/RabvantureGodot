extends Node2D
class_name GameManager

@onready var main_camera : MainCamera = $Services/MainCamera
@onready var checkpoint_manager : CheckpointManager = $Services/CheckpointManager
@onready var tutorial_manager : TutorialManager = $Services/TutorialManager
@onready var main_canvas : MainCanvas = $Canvases/MainCanvas
@onready var pause_canvas : PauseCanvas = $Canvases/PauseCanvas
@onready var load_ad_canvas : LoadAdCanvas = $Canvases/LoadAdCanvas
@onready var level_setup : LevelSetup = $LevelSetup

@export var respawn_delay : float = 1.0
@export var spawn_transform : Node2D
@export var player : PlayerEntity

var spawn_position : Vector2
var score : int = 0
var is_game_ends : bool = false
var is_paused : bool = false

var death_count_after_first_time_watch_checkpoint_ad : int = -1
var has_first_time_watch_respawn_checkpoint_ad : bool = false
var is_show_respawn_checkpoint_ad_instruction : bool = false
var has_checkpoint : bool = false

signal on_paused(is_paused : bool)

func _ready() -> void:
	register_signal_callbacks()
	AudioManager.play_bgm()
	main_canvas.refresh_death_count_text()
	main_canvas.show_pause_panel(is_paused)
	main_canvas.respawn_checkpoint_instruction.visible = false
	cache_spawn_position()
	set_player_at_spawn_position()
	start_game()

func _process(_delta) -> void:
	handle_score()
	handle_pause_input()
	
func register_signal_callbacks() -> void:
	player.on_dead.connect(on_player_die.bind())
	main_canvas.pause_button.button_down.connect(on_pause_button_pressed.bind())
	pause_canvas.return_button.button_down.connect(on_return_to_game_button_pressed.bind())
	main_canvas.respawn_checkpoint_ad_load.connect(on_respawn_checkpoint_ad_load.bind())
	main_canvas.respawn_checkpoint_ad_failed.connect(on_respawn_checkpoint_ad_failed.bind())
	main_canvas.respawn_checkpoint_ad_rewarded.connect(on_respawn_checkpoint_ad_rewarded.bind())

func start_game() -> void:
	player.set_alive()
	main_camera.follow_target = player
	main_canvas.set_respawn_checkpoint_button_disabled(!has_checkpoint)
	is_show_respawn_checkpoint_ad_instruction = !has_first_time_watch_respawn_checkpoint_ad or (Global.death_count - death_count_after_first_time_watch_checkpoint_ad) % 5 == 0
	if (has_checkpoint and is_show_respawn_checkpoint_ad_instruction):
		show_checkpoint_respawn_ad_instruction(3)
	is_game_ends = false

func ends_game() -> void:
	main_camera.follow_target = null
	main_canvas.refresh_death_count_text()
	has_checkpoint = checkpoint_manager.has_checkpoint()
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
	main_canvas.show_pause_panel(!is_paused)
	set_game_paused(!is_paused)

func on_pause_button_pressed() -> void:
	if (is_paused): return
	on_toggle_paused()

func on_return_to_game_button_pressed() -> void:
	if (!is_paused): return
	on_toggle_paused()

func on_player_die() -> void:
	Global.death_count += 1
	FirebaseManager.log_death(Global.death_count)
	ends_game()

func set_game_paused(is_true:bool) -> void:
	is_paused = is_true
	on_paused.emit(is_true)

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
	player.global_position = spawn_position
	player.set_facing_right(true)

func set_player_at_checkpoint_position() -> void:
	if(has_checkpoint):
		player.global_position = checkpoint_manager.get_checkpoint()
		player.set_facing_right(checkpoint_manager.get_checkpoint_face_direction())
	else:
		print_debug("Unable to set player at checkpoint, checkpoint not found")

func show_checkpoint_respawn_ad_instruction(duration : float) -> void:
	main_canvas.respawn_checkpoint_instruction.visible = true
	
	await get_tree().create_timer(duration).timeout
	
	set_first_time_watch_respawn_checkpoint_ad(true)
	main_canvas.respawn_checkpoint_instruction.visible = false
	is_show_respawn_checkpoint_ad_instruction = false

func set_first_time_watch_respawn_checkpoint_ad(has_watch:bool) -> void:
	if (has_watch):
		if (!has_first_time_watch_respawn_checkpoint_ad):
			death_count_after_first_time_watch_checkpoint_ad = Global.death_count
			has_first_time_watch_respawn_checkpoint_ad = true
	else:
		death_count_after_first_time_watch_checkpoint_ad = -1
		has_first_time_watch_respawn_checkpoint_ad = false

func on_respawn_checkpoint_ad_load() -> void:
	set_first_time_watch_respawn_checkpoint_ad(true)
	main_canvas.respawn_checkpoint_instruction.visible = false
	is_show_respawn_checkpoint_ad_instruction = false
	load_ad_canvas.set_status_load()
	load_ad_canvas.visible = true
	set_game_paused(true)
	
func on_respawn_checkpoint_ad_failed(error_code : int, message : String) -> void:
	load_ad_canvas.set_status_failed(error_code, message)
	await get_tree().create_timer(2).timeout
	load_ad_canvas.visible = false
	set_game_paused(false)
	
func on_respawn_checkpoint_ad_rewarded(type : String, amount : int) -> void:
	load_ad_canvas.visible = false
	set_game_paused(false)
	set_player_at_checkpoint_position()

extends Node2D
class_name GameManager

@onready var player : PlayerEntity = $Player
@onready var main_camera : GameCamera = %Services/MainCamera
@onready var main_canvas : GameUI = %Services/MainCanvas
@onready var audio_manager : AudioManager = %Services/AudioManager

var is_paused : bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	SaveGame.load_json()
	register_signal_callbacks()
	set_locale()
	main_camera.follow_target = player
	main_canvas.refresh_ui()

func _process(_delta) -> void:
	handle_score()
	handle_pause_input()
	
func register_signal_callbacks() -> void:
	player.on_dead.connect(on_player_die.bind())
	main_canvas.pause_button.button_up.connect(on_toggle_paused.bind())

func set_locale() -> void:
	var locale = Global.locale if Global.locale == "" else OS.get_locale() 
	TranslationServer.set_locale(locale)

func handle_pause_input() -> void:
	if Input.is_action_just_released("ui_cancel"):
		on_toggle_paused()

func on_toggle_paused() -> void:
	set_game_paused(!is_paused)

func set_game_paused(is_true:bool) -> void:
	main_canvas.show_pause_panel(is_true)
	is_paused = is_true

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

extends CanvasLayer
class_name MainCanvas

@onready var game_manager : GameManager = $"/root/Game"
@onready var death_count_label : Label = %DeathCountLabel
@onready var score_label : Label = %ScoreLabel
@onready var pause_button : TextureButton = %PauseButton
@onready var respawn_checkpoint_button : TextureButton = %RespawnCheckpointButton
@onready var respawn_checkpoint_instruction : MarginContainer = %RespawnCheckPointInstruction

@export var pause_canvas : PauseCanvas
@export var load_ad_canvas : LoadAdCanvas

signal respawn_checkpoint_ad_load
signal respawn_checkpoint_ad_failed
signal respawn_checkpoint_ad_rewarded

func _ready() -> void:
	respawn_checkpoint_button.button_down.connect(load_respawn_checkpoint_ad.bind())

func refresh_death_count_text() -> void:
	death_count_label.text = str(Global.death_count)
	
func show_pause_panel(is_show:bool):
	pause_canvas.visible = is_show

func set_score(score : int) -> void:
	if (score > 1000):
		score_label.text = "%.2fkm" % (score / 1000.0)
	else:
		score_label.text = "%.fm" % score

func load_respawn_checkpoint_ad() -> void:
	if (game_manager.is_paused): return
	if (game_manager.is_game_ends): return
	
	respawn_checkpoint_ad_load.emit()
	
	var firebase_api = FirebaseAPI.new()
	var can_load = firebase_api.load_rewarded_ad(FirebaseManager.RESPAWN_CHECKPOINT_AD_ID, 
		on_respawn_checkpoint_ad_failed,
		on_respawn_checkpoint_ad_success)
	if (can_load):
		print_debug("Loading Respawn Checkpoint Ad...")
		load_ad_canvas.set_status_load()
		respawn_checkpoint_button.disabled = true
	else:
		print_debug("Failed load Respawn Checkpoint Ad, error : Pilum singleton not found!")
		load_ad_canvas.set_status_failed()
		await get_tree().create_timer(2).timeout
		respawn_checkpoint_ad_failed.emit()
	
func on_respawn_checkpoint_ad_failed(error_code, message) -> void:
	print_debug("Failed load Respawn Checkpoint Ad, error %s: %s" % [error_code, message])
	respawn_checkpoint_ad_failed.emit()
	
func on_respawn_checkpoint_ad_success(_type, _amount) -> void:
	respawn_checkpoint_button.disabled = false
	respawn_checkpoint_ad_rewarded.emit()

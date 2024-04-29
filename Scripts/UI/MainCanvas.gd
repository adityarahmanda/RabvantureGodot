extends CanvasLayer
class_name MainCanvas

@onready var death_count_label : Label = %DeathCountLabel
@onready var score_label : Label = %ScoreLabel
@onready var pause_button : TextureButton = %PauseButton
@onready var respawn_checkpoint_button : TextureButton = %RespawnCheckpointButton

@export var pause_canvas : PauseCanvas

signal respawn_checkpoint_ad_loaded
signal respawn_checkpoint_ad_failed
signal respawn_checkpoint_ad_rewarded

func _ready() -> void:
	respawn_checkpoint_button.button_down.connect(load_respawn_checkpoint_ad.bind())

func refresh_ui() -> void:
	death_count_label.text = str(Global.death_count)
	
func show_pause_panel(is_show:bool):
	pause_canvas.visible = is_show

func set_score(score : int) -> void:
	if (score > 1000):
		score_label.text = "%.2fkm" % (score / 1000.0)
	else:
		score_label.text = "%.fm" % score

func load_respawn_checkpoint_ad() -> void:
	if (!FirebaseManager.is_admob_initialized): return
	var firebase_api = FirebaseAPI.new()
	firebase_api.load_rewarded_ad(FirebaseManager.RESPAWN_CHECKPOINT_AD_ID, 
		on_respawn_checkpoint_ad_loaded,
		on_respawn_checkpoint_ad_failed,
		on_respawn_checkpoint_ad_rewarded)
	respawn_checkpoint_button.disabled = true

func on_respawn_checkpoint_ad_loaded() -> void:
	respawn_checkpoint_ad_loaded.emit()
	
func on_respawn_checkpoint_ad_failed(error_code, message) -> void:
	printerr("Failed load Respawn Checkpoint Ad, error %s: %s" % [error_code, message])
	
func on_respawn_checkpoint_ad_rewarded(_type, _amount) -> void:
	respawn_checkpoint_button.disabled = false
	respawn_checkpoint_ad_rewarded.emit()

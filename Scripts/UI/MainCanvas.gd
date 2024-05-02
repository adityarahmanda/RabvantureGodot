extends CanvasLayer
class_name MainCanvas

@onready var game_manager : GameManager = $"/root/Game"
@onready var death_count_label : Label = %DeathCountLabel
@onready var score_label : Label = %ScoreLabel
@onready var pause_button : TextureButton = %PauseButton
@onready var respawn_checkpoint_button : TextureButton = %RespawnCheckpointButton
@onready var respawn_checkpoint_instruction : MarginContainer = %RespawnCheckPointInstruction

@export var respawn_checkpoint_button_disabled_color : Color
@export var pause_canvas : PauseCanvas

signal respawn_checkpoint_ad_load
signal respawn_checkpoint_ad_failed(error_code : int, message : String)
signal respawn_checkpoint_ad_rewarded(type : String, amount : int)

func _ready() -> void:
	respawn_checkpoint_button.button_down.connect(load_respawn_checkpoint_ad.bind())

func refresh_death_count_text() -> void:
	death_count_label.text = str(Global.death_count)
	
func show_pause_panel(is_show:bool):
	pause_canvas.visible = is_show

func set_respawn_checkpoint_button_disabled(is_true : bool) -> void:
	respawn_checkpoint_button.modulate = respawn_checkpoint_button_disabled_color if is_true else Color.WHITE
	respawn_checkpoint_button.disabled = is_true

func set_score(score : int) -> void:
	if (score > 1000):
		score_label.text = "%.2fkm" % (score / 1000.0)
	else:
		score_label.text = "%.fm" % score

func load_respawn_checkpoint_ad() -> void:
	if (game_manager.is_paused): return
	
	respawn_checkpoint_ad_load.emit()
	var google_services = GoogleServicesAPI.new()
	var can_load = google_services.load_rewarded_ad(GoogleServicesManager.RESPAWN_CHECKPOINT_AD_ID, 
		on_respawn_checkpoint_ad_failed,
		on_respawn_checkpoint_ad_rewarded)
	if (can_load):
		print_debug("Loading Respawn Checkpoint Ad...")
		set_respawn_checkpoint_button_disabled(true)
	else:
		on_respawn_checkpoint_ad_failed(-1, "Google Services singleton not found")
	
func on_respawn_checkpoint_ad_failed(error_code : int, message : String) -> void:
	print_debug("Failed load Respawn Checkpoint Ad, error %s: %s" % [error_code, message])
	set_respawn_checkpoint_button_disabled(false)
	respawn_checkpoint_ad_failed.emit(error_code, message)
	
func on_respawn_checkpoint_ad_rewarded(type : String, amount : int) -> void:
	print_debug("Get reward from Respawn Checkpoint Ad success, reward : %s, %s" % [type, amount])
	set_respawn_checkpoint_button_disabled(false)
	respawn_checkpoint_ad_rewarded.emit(type, amount)

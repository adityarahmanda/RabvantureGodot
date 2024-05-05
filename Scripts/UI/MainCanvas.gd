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

var respawn_checkpoint_ad_timer : float = 0.0
var respawn_checkpoint_ad_timeout : float = 10.0
var is_loading_respawn_ad : bool = false

signal respawn_checkpoint_ad_load
signal respawn_checkpoint_ad_failed(error_code : int)
signal respawn_checkpoint_ad_rewarded(type : String, amount : int)

func _ready() -> void:
	respawn_checkpoint_button.button_down.connect(load_respawn_checkpoint_ad.bind())
	GoogleServicesManager.google_service.connect_signal(GoogleServicesAPI.SIGNAL_ADMOB_REWARDED, on_respawn_checkpoint_ad_rewarded)

func _process(delta):
	if !is_loading_respawn_ad: return
	if GoogleServicesManager.is_rewarded_ad_loaded():
		GoogleServicesManager.show_rewarded_ad()
		is_loading_respawn_ad = false
		return
	if !GoogleServicesManager.is_connected_to_network():
		on_respawn_checkpoint_ad_failed(LoadAdCanvas.FAILED_AD_NO_INTERNET)
		is_loading_respawn_ad = false
		return
	if !GoogleServicesManager.has_gdpr_consent_for_ads():
		on_respawn_checkpoint_ad_failed(LoadAdCanvas.FAILED_AD_NO_CONSENT_GDPR)
		is_loading_respawn_ad = false
		return
	if !GoogleServicesManager.any_ad_to_load:
		on_respawn_checkpoint_ad_failed(LoadAdCanvas.FAILED_AD_NO_ADS_TO_LOAD)
		is_loading_respawn_ad = false
		return
	if respawn_checkpoint_ad_timer > 0:
		respawn_checkpoint_ad_timer -= delta
	if respawn_checkpoint_ad_timer <= 0:
		on_respawn_checkpoint_ad_failed(LoadAdCanvas.FAILED_AD_TIMEOUT)
		is_loading_respawn_ad = false

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
	print_debug("Loading Respawn Checkpoint Ad...")
	respawn_checkpoint_ad_load.emit()
	if OS.get_name() == "Android":
		GoogleServicesManager.load_rewarded_ad()
		respawn_checkpoint_ad_timer = respawn_checkpoint_ad_timeout
		is_loading_respawn_ad = true
	else:
		on_respawn_checkpoint_ad_failed(LoadAdCanvas.FAILED_AD_WRONG_PLATFORM)

func on_respawn_checkpoint_ad_failed(error_code : int) -> void:
	respawn_checkpoint_ad_failed.emit(error_code)

func on_respawn_checkpoint_ad_rewarded(type : String, amount : int) -> void:
	respawn_checkpoint_ad_rewarded.emit(type, amount)

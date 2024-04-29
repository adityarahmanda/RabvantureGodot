extends Node

var is_admob_initialized : bool = false

const GAME_ENDS_EVENT = "game_ends"
const DEATH_EVENT = "death"
const RESPAWN_CHECKPOINT_AD_ID = "ca-app-pub-7764262309445081/6616127541"

func _ready() -> void:
	var firebase_api = FirebaseAPI.new()
	firebase_api.load_native_tools(false, "", on_admob_initialized)

func on_admob_initialized(_error_code, _message) -> void:
	is_admob_initialized = true
	
func log_open_apps() -> void:
	var firebase_api = FirebaseAPI.new()
	firebase_api.log_event(AnalyticsEvent.APP_OPEN)

func log_game_ends(status:String, score:float) -> void:
	var firebase_api = FirebaseAPI.new()
	firebase_api.log_event(GAME_ENDS_EVENT, { "status": status, "score": score })

func log_death(death_count:float) -> void:
	var firebase_api = FirebaseAPI.new()
	firebase_api.log_event(DEATH_EVENT, { "death_count": death_count })

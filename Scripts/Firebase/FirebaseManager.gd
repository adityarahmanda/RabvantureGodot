extends Node

class GameEvent:
	const GAME_ENDS = "game_ends"
	const DEATH = "death"

var firebase_api : FirebaseAPI

func _ready() -> void:
	firebase_api = FirebaseAPI.new()
	firebase_api.set_signal_callback(on_firebase_error.bind(), on_admob_init_complete.bind(), on_gdpr_consent_error.bind())
	firebase_api.load_native_tools(false, "")

func on_firebase_error() -> void:
	print_debug("firebase error")

func on_admob_init_complete() -> void:
	print_debug("admob initialization complete")

func on_gdpr_consent_error(error_code, message) -> void:
	printerr("gdpr error %s : %s" % [error_code, message])

func log_open_apps() -> void:
	firebase_api.log_event(AnalyticsEvent.APP_OPEN)

func log_game_ends(status:String, score:float) -> void:
	firebase_api.log_event(GameEvent.GAME_ENDS, { "status": status, "score": score })

func log_death(death_count:float) -> void:
	firebase_api.log_event(GameEvent.DEATH, { "death_count": death_count })

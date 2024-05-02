extends Node

const GAME_ENDS_EVENT = "game_ends"
const DEATH_EVENT = "death"
const RESPAWN_CHECKPOINT_AD_ID = "ca-app-pub-7764262309445081/6616127541"
const TEST_DEVICE_ID = "01DE804E21955A1A23B125B94C74B357"
const REACH_1000_ACHIEVEMENT_ID = "CgkI6Onlmr0MEAIQAg"
const CHALLENGER_1000_ACHIEVEMENT_ID = "CgkI6Onlmr0MEAIQAw"

var has_reach_1000 : bool = false
var has_challenge_1000 : bool = false

func _ready() -> void:
	print_debug("Loading Google Services Tools...")
	var is_test_mode = OS.is_debug_build()
	var google_services = get_google_services()
	google_services.initialize_analytics()
	google_services.initialize_admob(is_test_mode, TEST_DEVICE_ID)
	google_services.initialize_play_games()

func check_unlock_achievement(score:int, is_use_respawn:bool) -> void:
	check_unlock_reach_achievement(score)
	if !is_use_respawn:
		check_unlock_challenger_achievement(score)

func check_unlock_reach_achievement(score) -> void:
	if score >= 1000 and !has_reach_1000:
		get_google_services().unlock_achievement(REACH_1000_ACHIEVEMENT_ID)
		has_reach_1000 = true

func check_unlock_challenger_achievement(score) -> void:
	if score >= 1000 and !has_challenge_1000:
		get_google_services().unlock_achievement(CHALLENGER_1000_ACHIEVEMENT_ID)
		has_challenge_1000 = true

func log_open_apps() -> void:
	get_google_services().log_event(AnalyticsEvent.APP_OPEN)

func log_game_ends(status:String, score:float) -> void:
	get_google_services().log_event(GAME_ENDS_EVENT, { "status": status, "score": score })

func log_death(death_count:float) -> void:
	get_google_services().log_event(DEATH_EVENT, { "death_count": death_count })

func get_google_services() -> GoogleServicesAPI:
	return GoogleServicesAPI.new()

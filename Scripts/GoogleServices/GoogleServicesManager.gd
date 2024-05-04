extends Node

# Mobile Ads
const TEST_DEVICE_ID = "01DE804E21955A1A23B125B94C74B357"

# Mobile Ads - Admob Ad units
const RESPAWN_CHECKPOINT_AD_ID = "ca-app-pub-7764262309445081/6616127541"

# Play Games - Achiements
const REACH_1000_ACHIEVEMENT_ID = "CgkI6Onlmr0MEAIQAg"
const CHALLENGER_1000_ACHIEVEMENT_ID = "CgkI6Onlmr0MEAIQAw"

# Analytics events
const GAME_ENDS_EVENT = "game_ends"
const DEATH_EVENT = "death"

var google_service : GoogleServicesAPI
var has_reach_1000 : bool = false
var has_challenge_1000 : bool = false
var is_rewarded_ad_loaded : bool = false
var any_ad_to_load : bool = true
var is_network_available : bool = false

func _ready() -> void:
	print_debug("Loading Google Services Tools...")
	var is_test_mode = OS.is_debug_build()
	google_service = GoogleServicesAPI.new()
	google_service.initialize_analytics()
	google_service.initialize_mobile_ads(is_test_mode, TEST_DEVICE_ID)
	google_service.initialize_play_games()
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_CONNECTIVITY_AVAILABLE, on_connectivity_available)
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_CONNECTIVITY_LOST, on_connectivity_lost)
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_MOBILE_ADS_INIT_COMPLETE, on_mobile_ads_init_complete)
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_CONSENT_FORM_DISMISSED, on_consent_form_dismissed)
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_ADMOB_REWARDED_LOADED, on_rewarded_ad_loaded)
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_ADMOB_REWARDED_FAIL_TO_LOAD, on_rewarded_ad_fail_to_load)
	google_service.connect_signal(GoogleServicesAPI.SIGNAL_ADMOB_REWARDED_DISMISSED_FULLSCREEN_CONTENT, on_rewarded_ad_dismissed)

func on_connectivity_available() -> void:
	if !is_rewarded_ad_loaded:
		load_rewarded_ad()
	is_network_available = true

func on_connectivity_lost() -> void:
	is_network_available = false

func on_mobile_ads_init_complete() -> void:
	load_rewarded_ad()

func on_consent_form_dismissed() -> void:
	load_rewarded_ad()

func on_rewarded_ad_loaded() -> void:
	any_ad_to_load = true
	is_rewarded_ad_loaded = true

func on_rewarded_ad_fail_to_load(error_code:int, _message:String) -> void:
	if error_code == AdmobError.ERROR_CODE_NO_FILL or error_code == AdmobError.ERROR_CODE_MEDIATION_NO_FILL:
		any_ad_to_load = false
	is_rewarded_ad_loaded = false

func on_rewarded_ad_dismissed() -> void:
	load_rewarded_ad()
	
func load_rewarded_ad() -> void:
	if is_connected_to_network() and has_gdpr_consent_for_ads():
		google_service.load_rewarded_ad(RESPAWN_CHECKPOINT_AD_ID)
		is_rewarded_ad_loaded = false

func show_rewarded_ad() -> void:
	if is_rewarded_ad_loaded:
		google_service.show_loaded_rewarded_ad()
	else:
		load_rewarded_ad()

func show_achievements() -> void:
	google_service.show_achievements()

func show_privacy_options_form() -> void:
	google_service.show_privacy_options_form()

func has_gdpr_consent_for_ads() -> bool:
	return google_service.has_gdpr_consent_for_ads()

func check_unlock_achievement(score:int, is_use_respawn:bool) -> void:
	check_unlock_reach_achievement(score)
	if !is_use_respawn:
		check_unlock_challenger_achievement(score)

func check_unlock_reach_achievement(score) -> void:
	if score >= 1000 and !has_reach_1000:
		google_service.unlock_achievement(REACH_1000_ACHIEVEMENT_ID)
		has_reach_1000 = true

func check_unlock_challenger_achievement(score) -> void:
	if score >= 1000 and !has_challenge_1000:
		google_service.unlock_achievement(CHALLENGER_1000_ACHIEVEMENT_ID)
		has_challenge_1000 = true

func log_game_ends(status:String, score:float) -> void:
	google_service.log_event(GAME_ENDS_EVENT, { "status": status, "score": score })

func log_death(death_count:float) -> void:
	google_service.log_event(DEATH_EVENT, { "death_count": death_count })

func is_connected_to_network() -> bool:
	return is_network_available || google_service.is_connected_to_network()

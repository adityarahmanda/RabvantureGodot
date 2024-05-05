extends Object
class_name GoogleServicesAPI

const SIGNAL_MOBILE_ADS_INIT_COMPLETE = "mobile_ads_init_complete"
const SIGNAL_CONSENT_FORM_DISMISSED = "consent_form_dismissed"
const SIGNAL_CONSENT_GDPR_ERROR = "consent_gdpr_error"
const SIGNAL_PLAY_GAMES_AUTH_COMPLETE = "play_games_auth_complete"
const SIGNAL_ADMOB_REWARDED = "admob_rewarded"
const SIGNAL_ADMOB_REWARDED_CLICKED = "admob_rewarded_clicked"
const SIGNAL_ADMOB_REWARDED_DISMISSED_FULLSCREEN_CONTENT = "admob_rewarded_dismissed_fullscreen_content"
const SIGNAL_ADMOB_REWARDED_FAILED_SHOW_FULLSCREEN_CONTENT = "admob_rewarded_failed_show_fullscreen_content"
const SIGNAL_ADMOB_REWARDED_IMPRESSION = "admob_rewarded_impression"
const SIGNAL_ADMOB_REWARDED_SHOWED_FULLSCREEN_CONTENT = "admob_rewarded_showed_fullscreen_content"
const SIGNAL_ADMOB_REWARDED_LOADED = "admob_rewarded_loaded"
const SIGNAL_ADMOB_REWARDED_FAIL_TO_LOAD = "admob_rewarded_fail_to_load"
const SIGNAL_CONNECTIVITY_AVAILABLE = "connectivity_available"
const SIGNAL_CONNECTIVITY_LOST = "connectivity_lost"
	
var google_services

func _init() -> void:
	if Engine.has_singleton("GoogleServices"):
		google_services = Engine.get_singleton("GoogleServices")

func connect_signal(service_signal:String, callback:Callable) -> void:
	if google_services:
		google_services.connect(service_signal, callback)
		
func initialize_analytics() -> void:
	if google_services:
		google_services.initializeAnalytics()
	else:
		print_debug("Analytics initialization error : GoogleServices singleton not found!")

func initialize_mobile_ads(test_mode:bool, test_device_id:String) -> void:
	if google_services:
		google_services.initializeMobileAds(test_mode, test_device_id)
	else:
		print_debug("Admob initialization error : GoogleServices singleton not found!")

func initialize_play_games() -> void:
	if google_services:
		google_services.initializePlayGames()
	else:
		print_debug("Play Games initialization error : GoogleServices singleton not found!")

func load_rewarded_ad(ad_unit_id:String) -> void:
	if google_services:
		google_services.loadRewardedAd(ad_unit_id)

func show_loaded_rewarded_ad() -> void:
	if google_services:
		google_services.showLoadedRewardedAd()

func is_rewarded_ad_loaded() -> bool:
	if google_services:
		return google_services.isRewardedAdLoaded()
	else:
		return false

func is_authenticated() -> bool:
	if google_services:
		return google_services.isAuthenticated()
	else:
		return false

func has_gdpr_consent_for_ads() -> bool:
	if google_services:
		return google_services.hasGdprConsentForAds()
	else:
		return false

func log_event(event_name:String, params:Dictionary = {}) -> void:
	if google_services:
		google_services.logEvent(event_name, params)
		print_debug("Firebase log event : %s - %s" % [event_name, params])

func sign_in_play_games() -> void:
	if google_services:
		google_services.signInPlayGames()

func unlock_achievement(achievement_id:String) -> void:
	if google_services:
		google_services.unlockAchievement(achievement_id)

func show_achievements() -> void:
	if google_services:
		if is_authenticated():
			google_services.showAchievements()
		else:
			google_services.connect(SIGNAL_PLAY_GAMES_AUTH_COMPLETE, on_show_achievement_sign_in_complete)
			sign_in_play_games()

func on_show_achievement_sign_in_complete() -> void:
	if google_services:
		if is_authenticated():
			google_services.showAchievements()
		else:
			show_toast(tr("sign_in_games_to_continue"))
		google_services.disconnect(SIGNAL_PLAY_GAMES_AUTH_COMPLETE, on_show_achievement_sign_in_complete)

func show_privacy_options_form() -> void:
	if google_services:
		google_services.showPrivacyOptionsForm()

func is_connected_to_network() -> bool:
	if google_services:
		return google_services.isConnectedToNetwork()
	else:
		return false

func show_toast(message:String) -> void:
	if google_services:
		google_services.showToast(message)

func has_singleton() -> bool:
	return google_services

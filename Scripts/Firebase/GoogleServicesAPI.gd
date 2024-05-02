extends Object
class_name GoogleServicesAPI

var google_services

func _init() -> void:
	if Engine.has_singleton("GoogleServices"):
		google_services = Engine.get_singleton("GoogleServices")

func initialize_analytics() -> void:
	if google_services:
		google_services.initializeAnalytics()
	else:
		print_debug("Analytics initialization error : GoogleServices singleton not found!")

func initialize_admob(test_mode:bool, test_device_id:String) -> void:
	if google_services:
		google_services.initializeAdmob(test_mode, test_device_id)
	else:
		print_debug("Admob initialization error : GoogleServices singleton not found!")

func initialize_play_games() -> void:
	if google_services:
		google_services.initializePlayGames()
	else:
		print_debug("Play Games initialization error : GoogleServices singleton not found!")

func load_rewarded_ad(ad_unit_id:String, on_failed:Callable, on_rewarded:Callable)->bool:
	var success = true;
	if google_services:
		google_services.loadRewardedAd(ad_unit_id)
		google_services.connect("admob_rewarded_loaded", _on_rewarded_ad_loaded.bind())
		google_services.connect("admob_rewarded_fail_to_load", on_failed)
		google_services.connect("admob_rewarded", on_rewarded)
	else:
		success = false
	return success

func _on_rewarded_ad_loaded() -> void:
	if google_services:
		google_services.showLoadedRewardedAd()

func log_event(event_name:String, params:Dictionary = {}) -> void:
	if google_services:
		google_services.logEvent(event_name, params)
		print_debug("firebase log event : %s - %s" % [event_name, params])

func unlock_achievement(achievement_id:String) -> void:
	if google_services:
		google_services.unlockAchievement(achievement_id)

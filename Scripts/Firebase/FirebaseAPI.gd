extends Object
class_name FirebaseAPI

var pilum

func _init() -> void:
	if Engine.has_singleton("Pilum"):
		pilum = Engine.get_singleton("Pilum")

func load_native_tools(test_mode:bool, test_device_id:String, on_admob_initialized:Callable) -> void:
	if pilum:
		pilum.loadNativeTools(test_mode, test_device_id)
		pilum.connect("AdmobInicializationComplete", on_admob_initialized)
	else:
		printerr("Firebase API initialization error : Pilum singleton not found!")

func is_admob_initialized()->bool:
	var is_loaded = true;
	if pilum:
		is_loaded = pilum.isAdmobLoaded()
	else:
		is_loaded = false
	return is_loaded

func load_rewarded_ad(ad_unit_id:String, on_loaded:Callable, on_failed:Callable, on_rewarded:Callable)->bool:
	var success = true;
	if pilum:
		pilum.loadRewarded(ad_unit_id)
		pilum.connect("AdmobRewardedLoaded", on_loaded)
		pilum.connect("AdmobRewardedFailToLoad", on_failed)
		pilum.connect("AdmobRewarded", on_rewarded)
	else:
		success = false
	return success

func showAdRewardedLoaded() -> void:
	if pilum:
		pilum.showLoadedRewadedAd()

func log_event(event_name:String, params:Dictionary = {}) -> void:
	if pilum:
		pilum.registerEvent(event_name, params)
		print_debug("firebase log event : %s - %s" % [event_name, params])

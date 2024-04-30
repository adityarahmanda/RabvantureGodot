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
		print_debug("Firebase API initialization error : Pilum singleton not found!")

func load_rewarded_ad(ad_unit_id:String, on_failed:Callable, on_success:Callable)->bool:
	var success = true;
	if pilum:
		pilum.loadRewarded(ad_unit_id)
		pilum.connect("AdmobRewardedLoaded", _on_rewarded_ad_loaded.bind())
		pilum.connect("AdmobRewardedFailToLoad", on_failed)
		pilum.connect("AdmobRewarded", on_success)
	else:
		success = false
	return success

func _on_rewarded_ad_loaded() -> void:
	if pilum:
		pilum.showLoadedRewadedAd()

func log_event(event_name:String, params:Dictionary = {}) -> void:
	if pilum:
		pilum.registerEvent(event_name, params)
		print_debug("firebase log event : %s - %s" % [event_name, params])

extends Object
class_name FirebaseAPI

var pilum

func _init() -> void:
	if Engine.has_singleton("Pilum"):
		pilum = Engine.get_singleton("Pilum")
	else:
		printerr("Firebase API initialization error : Pilum singleton not found!")

func load_native_tools(test_mode:bool, test_device_id:String) -> void:
	if pilum:
		pilum.loadNativeTools(test_mode, test_device_id)

func set_signal_callback(firebase_error: Callable, admob_initialization_complete: Callable, gdpr_consent_error: Callable) -> void:
	if pilum:
		pilum.connect("FirebaseAnalyticsError", firebase_error)
		pilum.connect("AdmobInicializationComplete", admob_initialization_complete)
		pilum.connect("AdmobErrorGdprConsent", gdpr_consent_error)

func is_admob_loaded() -> bool:
	var loaded = true;
	if pilum:
		loaded = pilum.isAdmobLoaded()
	else:
		loaded = false
	return loaded

func log_event(event_name:String, params:Dictionary = {}) -> void:
	if pilum:
		pilum.registerEvent(event_name, params)
		print_debug("firebase log event : %s - %s" % [event_name, params])

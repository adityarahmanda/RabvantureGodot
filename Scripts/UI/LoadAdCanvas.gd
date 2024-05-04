extends CanvasLayer
class_name LoadAdCanvas

@onready var status_label = %StatusLabel

const FAILED_AD_TIMEOUT = 0
const FAILED_AD_WRONG_PLATFORM = 1
const FAILED_AD_NO_INTERNET = 2
const FAILED_AD_NO_CONSENT_GDPR = 3
const FAILED_AD_NO_ADS_TO_LOAD = 4

func set_status_load() -> void:
	status_label.text = "loading_ad"

func set_status_failed(error_code : int) -> void:
	match error_code:
		FAILED_AD_TIMEOUT:
			status_label.text = "failed_ad_timeout"
			print_debug("Failed load Respawn Checkpoint Ad: Timeout")
		FAILED_AD_WRONG_PLATFORM:
			status_label.text = "failed_ad_wrong_platform"
			print_debug("Failed load Respawn Checkpoint Ad: Only available for Android platform")
		FAILED_AD_NO_INTERNET:
			status_label.text = "failed_ad_no_internet"
			print_debug("Failed load Respawn Checkpoint Ad: Not connected to network")
		FAILED_AD_NO_CONSENT_GDPR:
			status_label.text = "failed_ad_no_consent_gdpr"
			print_debug("Failed load Respawn Checkpoint Ad: Has no GDPR consent to view ads")
		FAILED_AD_NO_ADS_TO_LOAD:
			status_label.text = "failed_ad_no_ads_to_load"
			print_debug("Failed load Respawn Checkpoint Ad: No Ads to load")

extends CanvasLayer
class_name LoadAdCanvas

@onready var status_label = %StatusLabel

func set_status_load() -> void:
	status_label.text = "loading_ad"

func set_status_failed(error_code : int, message : String) -> void:
	match error_code:
		0:
			status_label.text = "failed_ad_no_internet"
		_:
			status_label.text = "failed_ad"

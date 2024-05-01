extends CanvasLayer
class_name LoadAdCanvas

@onready var status_label = %StatusLabel

func set_status_load() -> void:
	status_label.text = "loading_ad"

func set_status_failed() -> void:
	status_label.text = "failed_ad"

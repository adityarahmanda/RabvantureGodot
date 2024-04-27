extends UISelector
class_name LanguageUISelector

func _on_refresh_label() -> void:
	Localization.set_locale(selected_item)

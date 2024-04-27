extends UISelector
class_name LanguageUISelector

func _on_initialize_label() -> void:
	selected_index = selection_list.find(Global.locale)
	refresh_label()

func _on_refresh_label() -> void:
	Localization.set_locale(selected_item)

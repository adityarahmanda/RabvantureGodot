extends UISelector
class_name LanguageUISelector

func _on_initialize_label() -> void:
	if (ProjectSettings.has_setting(Global.LOCALES_SETTINGS)):
		selection_list = ProjectSettings.get_setting(Global.LOCALES_SETTINGS)
	var locale_index = selection_list.find(Global.locale)
	selected_index = locale_index if locale_index != -1 else 0
	refresh_label()

func _on_refresh_label() -> void:
	Localization.set_locale(selected_item)

extends Node

signal on_locale_changed

var locales : Array = []

func set_locale(locale:String) -> void:
	if (locales.size() == 0 and ProjectSettings.has_setting(Global.locales_settings)):
		locales = ProjectSettings.get_setting(Global.locales_settings)
	
	locale = locale if locales.find(locale) != -1 else "en"
	Global.locale =  locale
	TranslationServer.set_locale(locale)
	on_locale_changed.emit()
	SaveGame.save_json()

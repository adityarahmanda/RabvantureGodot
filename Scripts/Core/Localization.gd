extends Node

signal on_locale_changed

var locales : Array = []
var deprecated_locales : Dictionary = { }

func cache_locale_settings() -> void:
	if (locales.size() == 0 and ProjectSettings.has_setting(Global.LOCALES_SETTINGS)):
		locales = ProjectSettings.get_setting(Global.LOCALES_SETTINGS)
	if (deprecated_locales.size() == 0 and ProjectSettings.has_setting(Global.DEPRECATED_LOCALES_SETTINGS)):
		deprecated_locales = ProjectSettings.get_setting(Global.DEPRECATED_LOCALES_SETTINGS)

func set_locale(locale:String) -> void:
	locale = convert_deprecated_locale(locale)
	locale = locale if locales.has(locale) else "en"
	Global.locale = locale
	TranslationServer.set_locale(locale)
	on_locale_changed.emit()
	SaveGame.save_json()

func convert_deprecated_locale(locale:String) -> String:
	return deprecated_locales[locale] if deprecated_locales.has(locale) else locale

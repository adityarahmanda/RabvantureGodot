extends Node

signal on_locale_changed

func set_locale(locale:String) -> void:
	Global.locale = locale
	TranslationServer.set_locale(locale)
	on_locale_changed.emit()
	SaveGame.save_json()

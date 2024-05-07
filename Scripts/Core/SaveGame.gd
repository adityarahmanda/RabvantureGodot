extends Node

const SAVE_PATH := "user://save.json"

func save_json() -> void:
	var data := {
		death_count = Global.death_count,
		locale = Global.locale
	}
	var json_data := JSON.stringify(data)
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file_access.store_line(json_data)
	file_access.close()

func load_json() -> void:
	if !FileAccess.file_exists(SAVE_PATH):
		return
	
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_data := file_access.get_line()
	file_access.close()
	
	var data: Dictionary = JSON.parse_string(json_data)
	Global.death_count = data.death_count
	Global.locale = data.locale

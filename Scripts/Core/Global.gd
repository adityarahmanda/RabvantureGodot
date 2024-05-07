extends Node

const LOCALES_SETTINGS : String = "game_config/locales"
const DEPRECATED_LOCALES_SETTINGS : String = "game_config/deprecated_locales"

var locale : String = ""
var death_count : int = 0

enum DeathType { FALL, HIT }

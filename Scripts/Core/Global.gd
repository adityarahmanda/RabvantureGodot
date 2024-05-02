extends Node

const LOCALES_SETTINGS : String = "game_config/locales"

var locale : String = ""
var death_count : int = 0

enum DeathType { FALL, HIT }

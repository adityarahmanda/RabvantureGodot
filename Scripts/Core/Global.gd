extends Node2D

var locales_settings : String = "game_config/locales"
var locale : String = ""
var death_count : int = 0

enum DeathType { FALL, HIT }

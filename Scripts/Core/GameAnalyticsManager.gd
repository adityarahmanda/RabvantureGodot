extends Node2D
class_name GameAnalyticsManager

var game_analytics

@export var game_keys : Dictionary
@export var secret_keys : Dictionary

var platform_os = OS.get_name()

func _notification(what):
	if game_analytics != null and what == NOTIFICATION_WM_CLOSE_REQUEST :
		game_analytics.onQuit()

func _ready():
	if(Engine.has_singleton("GameAnalytics")):
		game_analytics = Engine.get_singleton("GameAnalytics")
		game_analytics.setEnabledInfoLog(true)
		game_analytics.setEnabledVerboseLog(true)
		game_analytics.configureAutoDetectAppVersion(true)
		game_analytics.init(game_keys[platform_os], secret_keys[platform_os])

func log_game_start() -> void:
	if game_analytics != null:
		game_analytics.addProgressionEvent({
			"progressionStatus": "Start",
			"progression01": "game"
		})

func log_game_ends(status:String, score:float) -> void:
	if game_analytics != null:
		game_analytics.addProgressionEvent({
			"progressionStatus": status,
			"progression01": "game",
			"score": score
		})

func log_death_count(death_count:float) -> void:
	if game_analytics != null:
		game_analytics.addDesignEvent({
			"eventId": "death_count",
			"value": death_count
		})

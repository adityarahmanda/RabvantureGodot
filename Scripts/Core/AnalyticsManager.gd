extends Node

func log_open_apps() -> void:
	FirebaseAnalytics.logEvent(FirebaseAnalytics.Event.APP_OPEN, {})

func log_game_ends(status:String, score:float) -> void:
	FirebaseAnalytics.logEvent("game_ends", { "status": status, "score": score })

func log_death(death_count:float) -> void:
	FirebaseAnalytics.logEvent("death", { "death_count": death_count })

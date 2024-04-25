extends CanvasLayer
class_name GameUI

@onready var death_count_label : Label = %DeathCountLabel
@onready var score_label : Label = %ScoreLabel
@onready var pause_button : TextureButton = %PauseButton
@onready var pause_panel : Panel = %PausePanel

func refresh_ui() -> void:
	death_count_label.text = str(Global.death_count)
	
func show_pause_panel(is_show:bool):
	pause_panel.visible = is_show

func set_score(score : int) -> void:
	if (score > 1000):
		score_label.text = "%.2fkm" % (score / 1000.0)
	else:
		score_label.text = "%.fm" % score

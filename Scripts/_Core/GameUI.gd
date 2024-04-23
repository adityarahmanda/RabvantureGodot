extends CanvasLayer
class_name GameUI

@onready var death_count_label : Label = %DeathCountLabel
@onready var score_label : Label = %ScoreLabel
@onready var pauseButton : TextureButton = %PauseButton

func _ready() -> void:
	assign_button_callbacks()
	
func refresh_ui() -> void:
	death_count_label.text = str(Global.death_count)

func assign_button_callbacks() -> void:
	pauseButton.button_up.connect(on_pressed_pause_button.bind())
	
func on_pressed_pause_button() -> void:
	pass

func set_score(score : int) -> void:
	if (score > 1000):
		score_label.text = "%.2fkm" % (score / 1000.0)
	else:
		score_label.text = "%.fm" % score

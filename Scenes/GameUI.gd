extends CanvasLayer
class_name GameUI

@onready var death_count_label : Label = %DeathCountLabel
@onready var score_label : Label = %ScoreLabel
@onready var pauseButton : TextureButton = %PauseButton

func _ready() -> void:
	assign_button_callbacks()
	death_count_label.text = str(Global.death_count)

func assign_button_callbacks() -> void:
	pauseButton.button_up.connect(on_pressed_pause_button.bind())
	
func on_pressed_pause_button() -> void:
	print("Pause")

func set_score(score : int) -> void:
	score_label.text = str(score) + "m"

extends CanvasLayer
class_name PauseCanvas

@onready var return_button : TextureButton = %ReturnButton
@onready var achievements_button : TextureButton = %AchievementsButton

func _ready() -> void:
	achievements_button.button_down.connect(on_achievements_button_pressed.bind())

func on_achievements_button_pressed() -> void:
	GoogleServicesManager.show_achievements()

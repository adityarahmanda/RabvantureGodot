extends MarginContainer
class_name LocaleMarginController

@export var locale_margins : Dictionary

@onready var margin_left = get_theme_constant("margin_left")
@onready var margin_top = get_theme_constant("margin_top")
@onready var margin_right = get_theme_constant("margin_right")
@onready var margin_bottom = get_theme_constant("margin_bottom")

func _ready():
	Localization.on_locale_changed.connect(on_locale_changed.bind())

func on_locale_changed():
	if (locale_margins.has(Global.locale)):
		var margin = locale_margins[Global.locale]
		add_theme_constant_override("margin_left", margin.x)
		add_theme_constant_override("margin_top", margin.y)
		add_theme_constant_override("margin_right", margin.z)
		add_theme_constant_override("margin_bottom", margin.w)
	else:
		add_theme_constant_override("margin_left", margin_left)
		add_theme_constant_override("margin_top", margin_top)
		add_theme_constant_override("margin_right", margin_right)
		add_theme_constant_override("margin_bottom", margin_bottom)

extends CanvasLayer

@export var fade_in_duration : float = 1
@export var fade_out_duration : float = 1
@export var splash_duration : float = 3
@export var game_scene : Resource

@onready var logo : TextureRect = $SafeAreaRect/Logo
@onready var logo_animation : AnimationPlayer = $SafeAreaRect/Logo/AnimationPlayer

var status : ResourceLoader.ThreadLoadStatus

func _ready():
	SaveGame.load_json()
	ResourceLoader.load_threaded_request(game_scene.resource_path)
	initialize_locale()
	play_splash_screen_sequence()
	
func _process(_delta) -> void:
	handle_game_scene_loading()

func initialize_locale() -> void:
	var locale = Global.locale if Global.locale != "" else OS.get_locale()
	Localization.set_locale(locale)

func handle_game_scene_loading():
	if (status == ResourceLoader.THREAD_LOAD_LOADED): return
	status = ResourceLoader.load_threaded_get_status(game_scene.resource_path)

func play_splash_screen_sequence() -> void:
	logo.modulate = Color.TRANSPARENT
	logo_animation.play("SplashScreen")
	await create_tween().tween_property(logo, "modulate", Color.WHITE, fade_in_duration).set_ease(Tween.EASE_IN_OUT).finished
	await get_tree().create_timer(splash_duration).timeout
	while status != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
	await create_tween().tween_property(logo, "modulate", Color.TRANSPARENT, fade_out_duration).set_ease(Tween.EASE_OUT_IN).finished
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(game_scene.resource_path))

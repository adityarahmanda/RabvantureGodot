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
	GoogleServicesManager.log_open_apps()
	ResourceLoader.load_threaded_request(game_scene.resource_path)
	initialize_locale()
	play_splash_screen_sequence()
	
func _process(_delta) -> void:
	handle_game_scene_loading()

func initialize_locale() -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z]*(?=_)")
	var result = regex.search(OS.get_locale())
	var locale = Global.locale if Global.locale != "" else result.get_string()
	Localization.set_locale(locale)

func handle_game_scene_loading():
	if (status == ResourceLoader.THREAD_LOAD_LOADED): return
	status = ResourceLoader.load_threaded_get_status(game_scene.resource_path)

func play_splash_screen_sequence() -> void:
	logo.modulate = Color.TRANSPARENT
	logo_animation.play("SplashScreen")
	var tree = get_tree()	
	await create_tween().tween_property(logo, "modulate", Color.WHITE, fade_in_duration).set_ease(Tween.EASE_IN_OUT).finished
	await tree.create_timer(splash_duration).timeout
	while status != ResourceLoader.THREAD_LOAD_LOADED:
		await tree.process_frame
	var game_scene_resource = ResourceLoader.load_threaded_get(game_scene.resource_path)
	var game = game_scene_resource.instantiate()
	await create_tween().tween_property(logo, "modulate", Color.TRANSPARENT, fade_out_duration).set_ease(Tween.EASE_OUT_IN).finished
	tree.root.add_child(game)
	tree.unload_current_scene()
	tree.current_scene = game


extends Node2D

@onready var bgm_player : AudioStreamPlayer2D = $BGMPlayer

@export var sfx_player_pool_size : int = 2

var sfx_players : Array

const BGM_RESOURCE = preload("res://Audios/BGM/bgm.mp3")
const SFX_RESOURCES : AudioResource = preload("res://Audios/SFXResources.tres")

func _ready():
	bgm_player.stream = BGM_RESOURCE
	populate_sfx_players()

func play_bgm() -> void:
	bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()

func populate_sfx_players() -> void:
	for index in range(sfx_player_pool_size):
		instantiate_sfx_player()

func instantiate_sfx_player() -> AudioStreamPlayer2D:
	var player = AudioStreamPlayer2D.new()
	sfx_players.append(player)
	add_child(player)
	return player

func get_sfx_player() -> AudioStreamPlayer2D:
	for player:AudioStreamPlayer2D in sfx_players:
		if (player.has_stream_playback()): continue
		return player
	return instantiate_sfx_player()

func play_sfx(audio_name : String, randomize_pitch : bool = true) -> void:
	var pitch_setting = SFX_RESOURCES.get_random_audio_pitch(audio_name)
	var pitch_scale = pitch_setting.pitch_scale if pitch_setting != null else 1
	play_sfx_with_custom_pitch(audio_name, pitch_scale)

func play_sfx_with_custom_pitch(audio_name : String, pitch_scale : float = 1) -> void:
	var stream : AudioStream = SFX_RESOURCES.get_audio(audio_name)
	if (stream != null):
		var player = get_sfx_player()
		player.stream = stream
		player.pitch_scale = pitch_scale
		player.play()

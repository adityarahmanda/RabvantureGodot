extends Node2D
class_name AudioManager

@onready var bgm_player : AudioStreamPlayer2D = $BGMPlayer
@onready var sfx_player : AudioStreamPlayer2D = $SFXPlayer

const BGM_RESOURCE = preload("res://Audios/BGM/bgm.mp3")
const SFX_RESOURCES : AudioResource = preload("res://Audios/SFXResources.tres")

func _ready() -> void:
	bgm_player.stream = BGM_RESOURCE
	bgm_player.play()

func play_sfx(audio_name : String, randomize_pitch : bool = true) -> void:
	var stream : AudioStream = SFX_RESOURCES.get_audio(audio_name)
	if (stream != null):
		sfx_player.stream = stream
		if (randomize_pitch):
			var pitch_setting = SFX_RESOURCES.get_random_audio_pitch(audio_name)
			sfx_player.pitch_scale = pitch_setting.pitch_scale if pitch_setting != null else 1
		sfx_player.play()

func play_sfx_with_custom_pitch(audio_name : String, pitch_scale : float = 1) -> void:
	var stream : AudioStream = SFX_RESOURCES.get_audio(audio_name)
	if (stream != null):
		sfx_player.stream = stream
		sfx_player.pitch_scale = pitch_scale
		sfx_player.play()

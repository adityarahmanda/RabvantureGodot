extends Node2D
class_name AudioManager

@onready var bgm_player : AudioStreamPlayer2D = $BGMPlayer
@onready var sfx_player : AudioStreamPlayer2D = $SFXPlayer

const BGM_RESOURCE = preload("res://Audios/BGM/bgm.mp3")
const SFX_RESOURCES : AudioResource = preload("res://Audios/SFXResources.tres")

func _ready() -> void:
	bgm_player.stream = BGM_RESOURCE
	bgm_player.play(Global.last_bgm_time)

func play_sfx(audio_name : String) -> void:
	sfx_player.stream = SFX_RESOURCES.audios.get(audio_name)
	sfx_player.play()

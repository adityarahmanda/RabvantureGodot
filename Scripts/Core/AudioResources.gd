extends Resource
class_name AudioResource

@export var audios : Dictionary
@export var audios_pitch : Dictionary

func get_audio(audio_name:String) -> AudioStream:
	if (audios.has(audio_name)):
		return audios[audio_name] 
	return null

func get_random_audio_pitch(audio_name:String) -> AudioEffectPitchShift:
	if (audios_pitch.has(audio_name)):
		var rng = RandomNumberGenerator.new()
		var settings : Array = audios_pitch[audio_name];
		var index = rng.randi_range(0, settings.size() - 1)
		return settings[index]
	return null

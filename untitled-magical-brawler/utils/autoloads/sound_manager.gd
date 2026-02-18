extends Node


#region Bus Names
enum BUS_TYPE {
	MASTER,
	MUSIC,
	SFX
}
#endregion


#region External Variables
var _music_node : AudioStreamPlayer
var _volume_tween : Tween
var _pitch_tween : Tween

var _sound_effects : Dictionary[int, AudioStreamPlayer]
var _free_index : Array[int]
#endregion



#region Virtual Methods
func _ready() -> void:
	_music_node = AudioStreamPlayer.new()
	add_child(_music_node)
#endregion


#region Private Methods (Helper)
func _get_bus_name(bus : BUS_TYPE) -> StringName:
	match bus:
		BUS_TYPE.MASTER:
			return &"Master"
		BUS_TYPE.MUSIC:
			return &"Music"
		BUS_TYPE.SFX:
			return &"SFX"
	return &""

func _get_index() -> int:
	if _free_index.is_empty():
		return _sound_effects.size()
	return _free_index.pop_back()

func _finish_audio(idx : int) -> void:
	var audio : AudioStreamPlayer = _sound_effects.get(idx)
	audio.queue_free()
	
	_sound_effects.set(idx, null)
	_free_index.push_back(idx)
	
	if _free_index.size() == _sound_effects.size():
		_free_index.clear()
		_sound_effects.clear()
func _set_audio_linear(audio : AudioStreamPlayer, volume : float) -> void:
	audio.volume_db = linear_to_db(volume)
#endregion


#region Public Methods (SFX)
func create_sound_effect(
	stream : AudioStream,
	min_pitch : float = 1.0,
	max_pitch : float = 1.0,
	volume_db : float = 0.0
) -> int:
	var audio := AudioStreamPlayer.new()
	audio.stream = stream
	audio.pitch_scale = randf_range(min_pitch, max_pitch)
	audio.volume_db = volume_db
	audio.autoplay = true
	audio.bus = _get_bus_name(BUS_TYPE.SFX)
	
	var idx := _get_index()
	audio.finished.connect(_finish_audio.bind(idx))
	_sound_effects[idx] = audio
	
	return idx
func cancel_sound_effect(idx : int) -> void:
	if !_sound_effects.has(idx):
		return
	
	_finish_audio(idx)
func get_sound_effect(idx : int) -> AudioStreamPlayer:
	if !_sound_effects.has(idx):
		return null
	return _sound_effects.get(idx)
#endregion


#region Public Methods (Music)
func swap_music(
	new_stream : AudioStream,
	pitch : float = 1.0,
	volume_db : float = 0.0,
	trans_time : float = 0.5,
	ease_type : Tween.EaseType = Tween.EaseType.EASE_IN,
	trans_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
) -> void:
	if _volume_tween:
		_volume_tween.kill()
	
	var old_music := _music_node
	_music_node = AudioStreamPlayer.new()
	_music_node.stream = new_stream
	_music_node.pitch_scale = pitch
	_music_node.autoplay = true
	_music_node.bus = _get_bus_name(BUS_TYPE.MUSIC)
	add_child(_music_node)
	
	if is_zero_approx(trans_time):
		old_music.queue_free()
		_music_node.volume_db = volume_db
		return
	
	var old_tw := old_music.create_tween()
	old_tw.set_ease(ease_type)
	old_tw.set_trans(trans_type)
	old_tw.tween_method(
		_set_audio_linear.bind(old_music),
		db_to_linear(old_music.volume_db),
		0.0,
		trans_time
	)
	old_tw.tween_callback(old_music.queue_free)
	
	_music_node.volume_db = linear_to_db(0.0)
	fade_music(
		volume_db, trans_time,
		ease_type, trans_type
	)

func toggle_music(pause : bool) -> void:
	_music_node.stream_paused = pause
#endregion


#region Public Methods (Music Tweens)
func fade_music(
	volume_db : float = 0.0,
	trans_time : float = 0.5,
	ease_type : Tween.EaseType = Tween.EaseType.EASE_IN,
	trans_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
) -> void:
	if _volume_tween:
		_volume_tween.kill()
	if is_zero_approx(trans_time):
		_music_node.volume_db = volume_db
		return
	
	_volume_tween = _music_node.create_tween()
	_volume_tween.set_ease(ease_type)
	_volume_tween.set_trans(trans_type)
	_volume_tween.tween_method(
		_set_audio_linear.bind(_music_node),
		_music_node.volume_linear,
		db_to_linear(volume_db),
		trans_time
	)
	
func pitch_music(
	pitch : float = 0.0,
	trans_time : float = 0.5,
	ease_type : Tween.EaseType = Tween.EaseType.EASE_IN,
	trans_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
) -> void:
	if _pitch_tween:
		_pitch_tween.kill()
	if is_zero_approx(trans_time):
		_music_node.pitch_scale = pitch
		return
	
	_pitch_tween = _music_node.create_tween()
	_pitch_tween.set_ease(ease_type)
	_pitch_tween.set_trans(trans_type)
	_pitch_tween.tween_method(
		_set_audio_linear.bind(_music_node),
		_music_node.pitch_scale,
		pitch,
		trans_time
	)
#endregion

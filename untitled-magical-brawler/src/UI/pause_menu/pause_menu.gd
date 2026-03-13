@tool
extends MaxSizeContainer


#region Private Variables
var _fade_tween : Tween
#endregion


#region OnReady Variables
@onready var _music_slider: HSlider = %MusicSlider
@onready var _sfx_slider: HSlider = %SFXSlider
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_force_fade(is_paused())
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		set_paused(!is_paused())
#endregion


#region Private Methods (Fade Helper)
func _create_fade_tween(paused : bool) -> void:
	if _fade_tween:
		_fade_tween.kill()
		
	_fade_tween = create_tween()
	_fade_tween.tween_property(
		self,
		"modulate:a",
		int(paused),
		0.2
	)
func _force_fade(paused : bool) -> void:
	modulate.a = int(paused)
#endregion


#region Private Methods (On Button Press)
func _on_resume_game_btn_pressed() -> void:
	set_paused(false)

func _on_main_menu_btn_pressed() -> void:
	Global.main_controller.load_main_menu()
#endregion


#region Private Methods (Helper)
func _load_settings() -> void:
	_music_slider.value = SettingsHolder.get_bus_volume(
		SettingsHolder.BUS.MUSIC
	)
	_sfx_slider.value = SettingsHolder.get_bus_volume(
		SettingsHolder.BUS.SFX
	)
func _save_settings() -> void:
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.MUSIC, _music_slider.value
	)
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.SFX, _sfx_slider.value
	)
#endregion


#region Public Methods (Helper)
func set_paused(pause : bool) -> void:
	if !get_tree() || get_tree().paused == pause:
		return
	
	if pause:
		_load_settings()
	else:
		_save_settings()
	
	get_tree().paused = pause
	_create_fade_tween(pause)

func is_paused() -> bool:
	if !get_tree():
		return false
	
	return get_tree().paused
#endregion

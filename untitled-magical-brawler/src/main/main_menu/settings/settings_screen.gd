extends "res://src/main/main_menu/scripts/main_menu_subscreen.gd"


#region OnReady Variables
enum BUS {
	MASTER = 0,
	MUSIC = 1,
	SFX = 2
}
#endregion


#region OnReady Variables
@onready var _screen_shake_check_box: CheckBox = %ScreenShakeCheckBox
@onready var _master_audio_slider: HSlider = %MasterAudioSlider
@onready var _music_slider: HSlider = %MusicSlider
@onready var _sfx_slider: HSlider = %SFXSlider
#endregion



#region Virtual Methods
func _ready() -> void:
	_init_settings()
	
	_master_audio_slider.value_changed.connect(_master_changes)
	_music_slider.value_changed.connect(_music_changes)
	_sfx_slider.value_changed.connect(_sfx_changes)
#endregion


#region Private Methods
func _init_settings() -> void:
	_screen_shake_check_box.button_pressed = SettingsHolder.screenshake
	
	_master_audio_slider.value = SettingsHolder.get_bus_volume(
		SettingsHolder.BUS.MASTER
	)
	_music_slider.value = SettingsHolder.get_bus_volume(
		SettingsHolder.BUS.MUSIC
	)
	_sfx_slider.value = SettingsHolder.get_bus_volume(
		SettingsHolder.BUS.SFX
	)
func _update_settings() -> void:
	SettingsHolder.screenshake = _screen_shake_check_box.button_pressed
	
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.MASTER, _master_audio_slider.value
	)
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.MUSIC, _music_slider.value
	)
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.SFX, _sfx_slider.value
	)

func _master_changes(val : float) -> void:
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.MASTER, _master_audio_slider.value
	)
func _music_changes(val : float) -> void:
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.MUSIC, _music_slider.value
	)
func _sfx_changes(val : float) -> void:
	SettingsHolder.set_bus_volume(
		SettingsHolder.BUS.SFX, _sfx_slider.value
	)
#endregion

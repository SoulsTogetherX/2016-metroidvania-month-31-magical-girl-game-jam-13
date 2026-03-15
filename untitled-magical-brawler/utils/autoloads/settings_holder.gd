extends Node


#region OnReady Variables
enum BUS {
	MASTER = 0,
	MUSIC = 1,
	SFX = 2
}
#endregion


#region Public Variables
var screenshake : bool = true
#endregion



#region Public Variables
func _ready() -> void:
	add_to_group(
		GlobalLabels.groups.SAVEABLE_GROUP_NAME
	)
#endregion


#region Public Methods
func set_bus_volume(bus : BUS, linear : float) -> void:
	AudioServer.set_bus_volume_linear(
		bus, linear
	)
func get_bus_volume(bus : BUS) -> float:
	return AudioServer.get_bus_volume_linear(bus)
#endregion


#region Private Methods (Save/Load)
func _request_save() -> void:
	SaveManager.set_key(
		SaveManager.SAVE_KEYS.SETTINGS,
		[
			get_bus_volume(BUS.MASTER),
			get_bus_volume(BUS.MUSIC),
			get_bus_volume(BUS.SFX),
			screenshake
		]
	)
func _request_load() -> void:
	var vals = SaveManager.get_key(
		SaveManager.SAVE_KEYS.SETTINGS
	)
	
	if vals == null:
		return
	set_bus_volume(BUS.MASTER, vals[0])
	set_bus_volume(BUS.MUSIC, vals[1])
	set_bus_volume(BUS.SFX, vals[2])
	screenshake = vals[3]
#endregion

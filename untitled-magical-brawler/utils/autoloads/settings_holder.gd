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



#region Public Methods
func set_bus_volume(bus : BUS, linear : float) -> void:
	AudioServer.set_bus_volume_linear(
		bus, linear
	)
func get_bus_volume(bus : BUS) -> float:
	return AudioServer.get_bus_volume_linear(bus)
#endregion

@tool
class_name PlayerFallback extends Marker2D



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_register_self()
#endregion


#region Private Methods (Helper)
func _register_self() -> void:
	var room_manager : RoomManager = (Global.local_controller as RoomManager)
	if room_manager != null:
		room_manager.register_fail_back(global_position)
#endregion

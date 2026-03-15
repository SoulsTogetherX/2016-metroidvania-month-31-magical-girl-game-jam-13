extends AnimationPlayer



#region Virtual Methods
func _ready() -> void:
	var control := Global.local_controller
	if control is RoomManager:
		if control.saw_event("RedEvent"):
			instant_shift()
#endregion


#region Private Methods (On Signal)
func instant_shift() -> void:
	play("INSTANT_SHIFT")
func shift() -> void:
	play("SHIFT")
#endregion

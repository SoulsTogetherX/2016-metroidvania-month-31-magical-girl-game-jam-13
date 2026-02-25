extends StateActionNode


#region External Variables
@export_group("Modules")
@export var task : VelocityTaskManager

@export_group("States")
@export var stop_state : StateNode

@export_group("Other")
@export var timer : Timer
#endregion



#region Private Methods
func _force_end_state() -> void:
	force_change(stop_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache.set_value(&"stable_state", true)
	timer.timeout.connect(_force_end_state)
	timer.start()
func exit_state() -> void:
	timer.timeout.disconnect(_force_end_state)
	timer.stop()
	action_cache.set_value(&"stable_state", false)
#endregion

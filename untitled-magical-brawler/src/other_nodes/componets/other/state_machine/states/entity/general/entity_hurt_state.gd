extends StateNode


#region External Variables
@export_group("Modules")
@export var task : VelocityTaskManager
@export var h_direction_module : HDirectionComponent

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
	h_direction_module.disable = true
	timer.timeout.connect(_force_end_state)
	timer.start()
func exit_state() -> void:
	h_direction_module.disable = false
	timer.timeout.disconnect(_force_end_state)
	timer.stop()
#endregion

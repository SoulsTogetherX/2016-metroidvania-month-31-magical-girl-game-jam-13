extends StateNode


#region External Variables
@export_group("Modules")
@export var task : VelocityTaskManager

@export_group("States")
@export var end_state : StateNode

@export_group("Other")
@export var timer : Timer
#endregion




#region Private Methods
func _force_change() -> void:
	force_change.emit(end_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	timer.timeout.connect(_force_change)
	timer.start()
	
	task.task_begin(&"Flash_Task")
func exit_state() -> void:
	timer.timeout.disconnect(_force_change)
	timer.stop()
	
	task.task_end(&"Flash_Task")
#endregion

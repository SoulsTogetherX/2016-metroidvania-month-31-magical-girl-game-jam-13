extends StateNode


#region External Variables
@export_group("Modules")
@export var task : VelocityTaskManager

@export_group("States")
@export var end_state : StateNode

@export_group("Other")
@export var timer : Timer
#endregion



#region Public Methods (State Change)
func enter_state() -> void:
	timer.start()
	timer.timeout.connect(force_change.emit)
	
	task.task_begin(&"Hurt_Task")
func exit_state() -> void:
	task.task_end(&"Hurt_Task")
#endregion

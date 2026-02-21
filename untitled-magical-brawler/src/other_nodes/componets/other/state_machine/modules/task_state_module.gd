extends StateModule


#region External Variables
@export_group("Modules")
@export var task_manager : TaskManager

@export_group("Tasks")
@export var tasks : Array[StringName]
#endregion



#region Public Methods (State Change)
func enter_state() -> void:
	for task : StringName in tasks:
		task_manager.task_begin(task)
func exit_state() -> void:
	for task : StringName in tasks:
		task_manager.task_end(task)
#endregion

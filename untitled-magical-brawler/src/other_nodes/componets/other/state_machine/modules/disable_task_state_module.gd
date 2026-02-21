extends StateModule


#region External Variables
@export_group("Modules")
@export var task_manager : TaskManager

@export_group("Tasks")
@export var tasks : Array[StringName]

@export_group("Setting")
@export var disable_on_enter : bool = true
#endregion



#region Public Methods (State Change)
func enter_state() -> void:
	for task : StringName in tasks:
		task_manager.task_disable(task, disable_on_enter)
func exit_state() -> void:
	for task : StringName in tasks:
		task_manager.task_disable(task, !disable_on_enter)
#endregion

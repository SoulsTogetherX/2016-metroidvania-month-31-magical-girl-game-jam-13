extends StateModule


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var task_manager : TaskManager

@export_group("Settings")
@export var task : TaskNode
#endregion



#region Public Methods (State Change)
func enter_state() -> void:
	task_manager.task_begin(
		task,
		{
			&"move_dir": action_cache_module.get_value.bind(&"h_direction")
		}
	)
func exit_state() -> void:
	task_manager.task_end(task)
#endregion

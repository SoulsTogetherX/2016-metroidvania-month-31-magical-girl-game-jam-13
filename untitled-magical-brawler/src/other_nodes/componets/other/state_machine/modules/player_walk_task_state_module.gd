extends StateModule


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var task_manager : TaskManager
#endregion



#region Public Methods (State Change)
func enter_state() -> void:
	task_manager.task_begin(
		&"Walk_Task",
		{
			&"move_dir": action_cache_module.get_state.bind(&"h_movement"),
			&"on_floor": action_cache_module.is_action.bind(&"on_floor")
		}
	)
func exit_state() -> void:
	task_manager.task_end(&"Walk_Task")
#endregion

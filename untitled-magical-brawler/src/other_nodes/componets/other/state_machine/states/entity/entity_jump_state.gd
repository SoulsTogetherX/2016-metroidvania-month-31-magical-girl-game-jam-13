extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var task : VelocityTaskManager

@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if !action_cache_module.is_action(&"jumping"):
		return stop_state
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache_module.set_state(&"has_jumped", true)
	
	task.task_begin(&"Jump_Task")
	task.task_begin(
		&"Walk_Task",
		{
			&"move_dir": action_cache_module.get_state.bind(&"h_movement"),
			&"on_floor": action_cache_module.is_action.bind(&"on_floor")
		}
	)
func exit_state() -> void:
	task.task_end(&"Jump_Task")
	task.task_end(&"Walk_Task")
#endregion

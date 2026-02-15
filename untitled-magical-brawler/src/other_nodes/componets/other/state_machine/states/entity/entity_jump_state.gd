extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_c : ActionCacheComponent
@export var task : VelocityTaskManager

@export_group("States")
@export var fall_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	return _check_state()
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return _check_state()
func enter_state() -> void:
	task.task_begin(&"Jump_Task")
	task.task_begin(
		&"Walk_Task",
		{
			&"move_dir": func(): return action_cache_c.get_direction(&"movement").x,
			&"on_floor": action_cache_c.is_action.bind(&"on_floor")
		}
	)
func exit_state() -> void:
	task.task_end(&"Jump_Task")
	task.task_end(&"Walk_Task")
#endregion


#region Private Methods (Helper)
func _check_state() -> StateNode:
	if !action_cache_c.is_action(&"jumping"):
		return fall_state
	return null
#endregion

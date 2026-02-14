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
	if !action_cache_c.is_jumping():
		return fall_state
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	task.task_begin(&"Jump_Task")
	task.task_begin(
		&"Walk_Task",
		{
			&"get_move_dir": action_cache_c.get_move_direction,
			&"is_on_ground": action_cache_c.is_on_ground
		}
	)
func exit_state() -> void:
	task.task_end(&"Jump_Task")
	task.task_end(&"Walk_Task")
#endregion

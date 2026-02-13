extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var task : VelocityTaskManager

@export_group("States")
@export var fall_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if !action_cache.is_jumping():
		return fall_state
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	task.begin_task(&"Jump_Task")
	task.begin_task(
		&"Walk_Task",
		{
			&"get_move_dir": action_cache.get_move_direction,
			&"is_on_ground": action_cache.is_on_ground
		}
	)
func exit_state() -> void:
	task.end_task(&"Jump_Task")
	task.end_task(&"Walk_Task")
#endregion

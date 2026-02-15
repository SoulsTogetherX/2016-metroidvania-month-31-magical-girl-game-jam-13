extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_c : ActionCacheComponent
@export var task : VelocityTaskManager

@export_group("States")
@export var idle_state : StateNode
@export var move_state : StateNode
@export var jump_state : StateNode
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
	task.task_begin(&"Slowdown_Task")
func exit_state() -> void:
	task.task_end(&"Slowdown_Task")
#endregion


#region Private Methods (Helper)
func _check_state() -> StateNode:
	if action_cache_c.is_action(&"jumping"):
		return jump_state
	if !action_cache_c.is_action(&"on_floor"):
		return fall_state
	if action_cache_c.is_action(&"moving"):
		return move_state
	if task.velocity_c.attempting_idle():
		return idle_state
	return null
#endregion

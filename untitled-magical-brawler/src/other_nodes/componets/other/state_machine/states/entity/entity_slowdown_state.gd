extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var task : VelocityTaskManager

@export_group("States")
@export var idle_state : StateNode
@export var move_state : StateNode
@export var jump_state : StateNode
@export var fall_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if action_cache.is_jumping():
		return jump_state
	if !action_cache.is_on_ground():
		return fall_state
	if action_cache.is_moving():
		return move_state
	if task.velocity.attempting_idle():
		return idle_state
	return null
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	if action_cache.is_moving():
		return move_state
	if task.velocity.attempting_idle():
		return idle_state
	return null
func enter_state() -> void:
	task.task_begin(&"Slowdown_Task")
func exit_state() -> void:
	task.task_end(&"Slowdown_Task")
#endregion

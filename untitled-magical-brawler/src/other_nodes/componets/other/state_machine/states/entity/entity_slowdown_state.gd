extends MachineState


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var task : TaskManager

@export_group("States")
@export var idle_state : MachineState
@export var move_state : MachineState
@export var jump_state : MachineState
@export var fall_state : MachineState
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> MachineState:
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
func state_passthrough() -> MachineState:
	if action_cache.is_moving():
		return move_state
	if task.velocity.attempting_idle():
		return idle_state
	return null
func enter_state() -> void:
	task.begin_task(&"Slowdown_Task")
func exit_state() -> void:
	task.end_task(&"Slowdown_Task")
#endregion

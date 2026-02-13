extends State


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var movement : MovementComponent

@export_group("States")
@export var idle_state : State
@export var move_state : State
@export var jump_state : State
@export var fall_state : State
#endregion



#region Public Virtual Methods
func process_physics(delta: float) -> State:
	if action_cache.is_jumping():
		return jump_state
	if !action_cache.is_on_ground():
		return fall_state
	if action_cache.is_moving():
		return move_state
	if movement.velocity.attempting_idle():
		return idle_state
	
	movement.horizontal_slowdown(delta)
	return null
#endregion

#region Public Methods (State Change)
func state_passthrough() -> State:
	if action_cache.is_moving():
		return move_state
	if movement.velocity.attempting_idle():
		return idle_state
	return null
func exit_state() -> void:
	movement.stop_horizontal_movement()
#endregion

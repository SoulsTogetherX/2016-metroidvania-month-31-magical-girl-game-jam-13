extends State


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var movement : MovementComponent

@export_group("States")
@export var slowdown_state : State
@export var jump_state : State
@export var fall_state : State
#endregion



#region Public Virtual Methods
func process_physics(delta: float) -> State:
	if action_cache.is_jumping():
		return jump_state
	if !action_cache.is_on_ground():
		return fall_state
	if !action_cache.is_moving():
		return slowdown_state
	
	movement.horizontal_movement(delta)
	return null
#endregion

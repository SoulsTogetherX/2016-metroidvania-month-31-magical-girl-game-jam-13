extends State


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var movement : MovementComponent

@export_group("States")
@export var fall_state : State
#endregion



#region Public Virtual Methods
func process_physics(delta: float) -> State:
	if !action_cache.is_jumping():
		return fall_state
	
	movement.horizontal_movement(delta)
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	movement.jump()
func exit_state() -> void:
	movement.stop_jump()
#endregion

extends MachineState


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent

@export_group("States")
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
	return null
#endregion

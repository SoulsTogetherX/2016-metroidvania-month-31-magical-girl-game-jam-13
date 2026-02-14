extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_c : ActionCacheComponent

@export_group("States")
@export var move_state : StateNode
@export var jump_state : StateNode
@export var fall_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if action_cache_c.is_jumping():
		return jump_state
	if !action_cache_c.is_on_ground():
		return fall_state
	if action_cache_c.is_moving():
		return move_state
	return null
#endregion

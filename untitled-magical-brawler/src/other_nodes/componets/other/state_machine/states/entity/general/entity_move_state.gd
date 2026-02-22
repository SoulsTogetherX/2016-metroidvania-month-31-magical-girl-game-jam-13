extends StateActionNode


#region External Variables
@export_group("States")
@export var jump_state : StateNode
@export var fall_state : StateNode
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"player_up":
			force_change(jump_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"on_floor":
			force_change(fall_state)
		&"moving":
			force_change(stop_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	if !action_cache.is_action(&"on_floor"):
		return fall_state
	
	return null
#endregion

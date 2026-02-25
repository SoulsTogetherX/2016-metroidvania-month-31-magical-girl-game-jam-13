extends StateActionNode


#region External Variables
@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"player_jump":
			force_change(stop_state)
		&"in_air":
			force_change(stop_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return null
func enter_state() -> void:
	action_cache.set_value(&"has_jumped", true)
	action_cache.force_action_signal(&"player_jump")
#endregion

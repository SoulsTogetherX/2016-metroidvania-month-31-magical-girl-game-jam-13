extends StateActionNode


#region External Variables
@export_group("States")
@export var normal_state : StateNode
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"ability_use":
			force_change(normal_state)
#endregion


#region Public Methods (State Change)da
func state_passthrough() -> StateNode:
	return null
#endregion

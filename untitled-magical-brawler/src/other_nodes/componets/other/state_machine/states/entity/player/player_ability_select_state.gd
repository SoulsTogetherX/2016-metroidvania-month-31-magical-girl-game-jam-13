extends StateActionNode


#region External Variables
@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"player_left":
			print("left")
		&"player_right":
			print("right")
		&"ability_use":
			force_change(stop_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return null
#endregion

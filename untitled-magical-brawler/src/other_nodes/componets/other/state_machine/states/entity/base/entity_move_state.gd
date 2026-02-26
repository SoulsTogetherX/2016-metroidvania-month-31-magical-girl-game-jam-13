extends StateActionNode


#region External Variables
@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"moving":
			force_change(stop_state)
#endregion

extends HSMBranch


#region External Variables
@export_group("States")
@export var normal_state : HSMBranch
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	if action_name == GlobalLabels.hsm_context.ACT_STUN:
		change_state(normal_state)
#endregion

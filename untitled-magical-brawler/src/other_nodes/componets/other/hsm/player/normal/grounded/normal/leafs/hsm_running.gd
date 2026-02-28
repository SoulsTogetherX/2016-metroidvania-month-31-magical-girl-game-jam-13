extends HSMBranch


#region External Variables
@export_group("States")
@export var stop_state : HSMBranch
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_MOVING:
			change_state(stop_state)
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return null
#endregion

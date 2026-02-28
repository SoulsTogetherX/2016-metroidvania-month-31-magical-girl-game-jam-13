extends HSMBranch


#region External Variables
@export_group("States")
@export var injured_state : HSMBranch
@export var normal_state : HSMBranch
#endregion



#region Public Virtual Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return normal_state
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_STUN:
			change_state(injured_state)
#endregion

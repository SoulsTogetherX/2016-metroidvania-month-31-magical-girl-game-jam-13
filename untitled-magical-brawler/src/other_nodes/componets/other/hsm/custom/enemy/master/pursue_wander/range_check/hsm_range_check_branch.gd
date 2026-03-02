extends HSMBranch


#region External Variables
@export_group("States")
@export var moving_state : HSMBranch
@export var stationary_state : HSMBranch

@export_group("Other")
@export_range(0.0, 1000.0, 0.001, "or_greater") var forgiveness : float = 100
#endregion



#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_OUT_OF_RANGE:
			change_state(moving_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_OUT_OF_RANGE:
			change_state(stationary_state)
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_OUT_OF_RANGE
	):
		return moving_state
	return stationary_state
#endregion

extends HSMBranch


#region External Variables
@export_group("States")
@export var jump_state : HSMBranch

@export_group("Jumpables")
@export var moving_state : HSMBranch
@export var stationary_state : HSMBranch
#endregion



#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_JUMPING:
			change_state(jump_state)
		GlobalLabels.hsm_context.ACT_MOVING:
			change_state(moving_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_MOVING:
			change_state(stationary_state)
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_MOVING
	):
		return moving_state
	return stationary_state
#endregion

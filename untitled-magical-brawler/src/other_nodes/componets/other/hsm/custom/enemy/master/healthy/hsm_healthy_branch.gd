extends HSMBranch


#region External Variables
@export_group("States")
@export var pursue_state : HSMBranch
@export var wander_state : HSMBranch
@export var stationary_state : HSMBranch

@export_group("Settings")
@export_range(0.0, 1000.0, 0.001, "or_greater") var forgiveness : float = 100
#endregion



#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER:
			change_state(pursue_state)
		GlobalLabels.hsm_context.ACT_MOVING:
			if get_context().is_action(
				GlobalLabels.hsm_context.ACT_PURSUING_PLAYER
			):
				change_state(pursue_state)
				return
			change_state(wander_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_PURSUING_PLAYER:
			change_state(stationary_state)
		GlobalLabels.hsm_context.ACT_MOVING:
			change_state(stationary_state)
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER
	):
		return pursue_state
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_MOVING
	):
		return wander_state
	return stationary_state
#endregion

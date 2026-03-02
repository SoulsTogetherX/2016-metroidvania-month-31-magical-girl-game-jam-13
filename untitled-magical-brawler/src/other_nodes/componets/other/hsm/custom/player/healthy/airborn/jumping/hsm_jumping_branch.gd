extends HSMBranch


#region External Variables
@export_group("States")
@export var fall_state : HSMBranch
@export var ground_state : HSMBranch
@export var jump_state : HSMBranch
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_JUMPING:
			change_state(fall_state)
		GlobalLabels.hsm_context.ACT_IN_AIR:
			change_state(ground_state)
#endregion


#region Public Methods (State Change)
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if !ctx.is_action(GlobalLabels.hsm_context.ACT_JUMPING):
		return ground_state
	return jump_state
#endregion

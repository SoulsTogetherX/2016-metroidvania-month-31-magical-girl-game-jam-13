extends HSMBranch


#region External Variables
@export_group("States")
@export var fall_state : HSMBranch
@export var ground_state : HSMBranch
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
	return null
func enter_state(_act : Node, ctx : HSMContext) -> void:
	ctx.set_value(&"has_jumped", true)
	ctx.force_action_signal(&"player_jump")
#endregion

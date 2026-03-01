extends HSMBranch


#region External Variables
@export_group("States")
@export var fall_state : HSMBranch
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return fall_state

func exit_state(_act : Node, ctx : HSMContext) -> void:
	ctx.set_value(GlobalLabels.hsm_context.VAL_JUMP_COUNT, 0)
	ctx.set_value(GlobalLabels.hsm_context.VAL_WALL_JUMP_COUNT, 0)
#endregion

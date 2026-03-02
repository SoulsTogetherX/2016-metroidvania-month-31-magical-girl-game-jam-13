extends HSMBranch


#region Public Methods (State Change)
func enter_state(_act : Node, ctx : HSMContext) -> void:
	var wall_jump_key := GlobalLabels.hsm_context.VAL_WALL_JUMP_COUNT
	ctx.set_value(wall_jump_key, ctx.get_value(wall_jump_key) + 1)
#endregion

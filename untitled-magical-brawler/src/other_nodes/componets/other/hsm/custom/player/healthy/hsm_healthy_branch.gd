extends HSMBranch


#region External Variables
@export_group("States")
@export var airborn_state : HSMBranch
@export var grounded_state : HSMBranch
#endregion



#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_IN_AIR
	):
		return airborn_state
	return grounded_state
#endregion

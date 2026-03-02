extends HSMBranch


#region External Variables
@export_group("States")
@export var hurt_state : HSMBranch
#endregion



#region Public State Change Methods
func passthrough_state(act : Node, _ctx : HSMContext) -> HSMBranch:
	return hurt_state
#endregion

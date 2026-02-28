extends HSMBranch


#region External Variables
@export_group("States")
@export var dead_state : HSMBranch
@export var hurt_state : HSMBranch
#endregion



#region Public State Change Methods
func passthrough_state(act : Node, _ctx : HSMContext) -> HSMBranch:
	var entity : CombatEntity = act
	
	if entity.get_health_component().is_dead():
		return dead_state
	return hurt_state
#endregion

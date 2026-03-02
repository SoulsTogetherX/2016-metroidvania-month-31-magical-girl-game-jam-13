extends HSMBranch


#region External Variables
@export_group("States")
@export var dead_state : HSMBranch
@export var normal_state : HSMBranch
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	if action_name == GlobalLabels.hsm_context.ACT_STUN:
		var entity : CombatEntity = get_actor()
		if entity.get_health_component().is_dead():
			change_state(dead_state)
			return
		change_state(normal_state)
#endregion

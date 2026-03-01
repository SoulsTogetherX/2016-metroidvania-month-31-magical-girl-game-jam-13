extends HSMBranch


#region External Variables
@export_group("States")
@export var injured_state : HSMBranch
@export var healthy_state : HSMBranch

@export_group("Tasks")
@export var gravity_task : TaskNode
#endregion



#region Public Virtual Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return healthy_state

func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_STUN:
			change_state(injured_state)
		GlobalLabels.hsm_context.ACT_IN_AIR:
			gravity_task.disabled = false
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_STUN:
			change_state(healthy_state)
		GlobalLabels.hsm_context.ACT_IN_AIR:
			gravity_task.disabled = true
#endregion

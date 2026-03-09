extends HSMBranch


#region External Variables
@export_group("States")
@export var airborn_state : HSMBranch
@export var grounded_state : HSMBranch
#endregion

@onready var ray := $"../../../VisualPivot/GroundRayCheck"

#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			var ctx := get_context()
			if ray.is_colliding():
				return
			
			if !ctx.is_action(
				GlobalLabels.hsm_context.ACT_JUMPING
			):
				change_state(airborn_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			var ctx := get_context()
			
			ctx.set_value(GlobalLabels.hsm_context.VAL_JUMP_COUNT, 0)
			change_state(grounded_state)
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_IN_AIR
	):
		return airborn_state
	return grounded_state
#endregion

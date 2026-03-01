extends HSMBranch


#region External Variables
@export_group("Paticles")
@export var jump_particles : CPUParticles2D
@export var double_jump_particles : CPUParticles2D
#endregion


#region Public Methods (State Change)
func enter_state(_act : Node, ctx : HSMContext) -> void:
	var jump_key := GlobalLabels.hsm_context.VAL_JUMP_COUNT
	var jump_count : int = ctx.get_value(jump_key)
	
	jump_particles.emitting = (jump_count == 0)
	double_jump_particles.emitting = (jump_count == 1)
	
	ctx.set_value(jump_key, jump_count + 1)
#endregion

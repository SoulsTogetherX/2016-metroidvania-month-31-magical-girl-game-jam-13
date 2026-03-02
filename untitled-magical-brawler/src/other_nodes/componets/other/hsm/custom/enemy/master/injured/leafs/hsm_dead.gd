extends HSMBranch


#region Private Methods
func _on_dead_end() -> void:
	var entity : BaseEntity = get_actor()
	entity.get_velocity_component().velocity = Vector2.ZERO
#endregion


#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			_on_dead_end()
#endregion


#region Public Methods (State Change)
func enter_state(_act : Node, ctx : HSMContext) -> void:
	if !ctx.is_action(GlobalLabels.hsm_context.ACT_IN_AIR):
		_on_dead_end()
#endregion

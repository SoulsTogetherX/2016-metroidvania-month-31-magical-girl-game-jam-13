extends HSMBranch


#region Private Variables
var _dead_mutex : bool
#endregion



#region Private Methods
func _on_dead_end() -> void:
	print(1)
	if _dead_mutex:
		return
	_dead_mutex = true
	print(2)
	
	var entity : BaseEntity = get_actor()
	entity.get_velocity_component().velocity = Vector2.ZERO
	entity.play_animation(
		GlobalLabels.animations.get_label(
			GlobalLabels.animations.ACTIONS.DEAD
		)
	)
#endregion


#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			_on_dead_end()
#endregion


#region Public Methods (State Change)
func enter_state(_act : Node, ctx : HSMContext) -> void:
	_dead_mutex = false
	
	if !ctx.is_action(GlobalLabels.hsm_context.ACT_IN_AIR):
		_on_dead_end()
#endregion

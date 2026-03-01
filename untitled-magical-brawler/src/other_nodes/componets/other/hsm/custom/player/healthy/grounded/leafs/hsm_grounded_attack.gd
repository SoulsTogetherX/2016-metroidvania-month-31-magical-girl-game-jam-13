extends HSMBranch


#region External Variables
@export_group("States")
@export var stop_state : HSMBranch

@export_group("Other")
@export var punch_delay : Timer
#endregion



#region Private Methods
func _end_punch() -> void:
	change_state(stop_state)
#endregion


#region Public Methods (State Change)
func enter_state(_act : Node, _ctx : HSMContext) -> void:
	punch_delay.timeout.connect(_end_punch)
	punch_delay.start()
func exit_state(_act : Node, ctx : HSMContext) -> void:
	punch_delay.timeout.disconnect(_end_punch)
	ctx.force_action_signal(
		GlobalLabels.hsm_context.ACT_JUMPING
	)
#endregion

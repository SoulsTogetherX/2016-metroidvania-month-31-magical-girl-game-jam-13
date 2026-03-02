extends HSMBranch


#region External Variables
@export_group("States")
@export var pursue_state : HSMBranch
@export var wander_state : HSMBranch

@export_group("Other")
@export var pursue_linger : Timer
#endregion



#region Virtual Methods
func _ready() -> void:
	pursue_linger.timeout.connect(_purse_end)
#endregion


#region Private Methods
func _purse_end() -> void:
	change_state(wander_state)
#endregion


#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER:
			pursue_linger.stop()
			change_state(pursue_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER:
			pursue_linger.start()
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER
	):
		return pursue_state
	return wander_state

func exit_state(_act : Node, _ctx : HSMContext) -> void:
	pursue_linger.stop()
#endregion

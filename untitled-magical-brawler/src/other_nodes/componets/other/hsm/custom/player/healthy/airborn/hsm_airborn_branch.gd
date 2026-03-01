extends HSMBranch


#region External Variables
@export_group("States")
@export var fall_state : HSMBranch

@export_group("Other")
@export var coyote_timer : Timer
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return fall_state

func enter_state(_act : Node, _ctx : HSMContext) -> void:
	if !coyote_timer:
		return
	coyote_timer.start()
#endregion

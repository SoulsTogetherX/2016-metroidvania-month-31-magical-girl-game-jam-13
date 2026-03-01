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


#region Public Methods (State Change)
func enter_state(_act : Node, _ctx : HSMContext) -> void:
	Global.camera.freeze_frame(0.0, 0.1)
	Global.camera.screen_shake(
		GlobalCamera.create_noise(
			250, 500.0
		),
		0.1, 0.0, 0.0
	)
#endregion

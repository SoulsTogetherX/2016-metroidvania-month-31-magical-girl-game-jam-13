extends HSMModule


#region External Variables
@export_group("Animations")
@export var time_scale : float = 0.0
@export_range(0, 10.0, 0.001, "or_greater") var freeze_duration : float = 0.1

@export_group("Animations")
@export var noise : PhantomCameraNoise2D
@export_range(0, 10.0, 0.001, "or_greater") var shake_duration : float = 0.3
@export_range(0, 10.0, 0.001, "or_greater") var growth_time : float = 0.0
@export_range(0, 10.0, 0.001, "or_greater") var delay_time : float = 0.2
#endregion



#region Public Methods (State Change)
func start_module(_act : Node, _ctx : HSMContext) -> void:
	Global.camera.freeze_frame(time_scale, freeze_duration)
	Global.camera.screen_shake(
		noise, shake_duration, growth_time, delay_time
	)
func end_module(_act : Node, _ctx : HSMContext) -> void:
	pass
#endregion

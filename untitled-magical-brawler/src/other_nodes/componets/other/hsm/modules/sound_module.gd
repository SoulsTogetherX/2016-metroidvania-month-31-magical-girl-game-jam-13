extends HSMModule


#region External Variables
@export_group("Animations")
@export var sound_effect : AudioStreamPlayer

@export_group("Settings")
@export var on_enter : bool = true
#endregion



#region Public Methods (State Change)
func start_module(_act : Node, _ctx : HSMContext) -> void:
	if !on_enter:
		return
	sound_effect.play()
func end_module(_act : Node, _ctx : HSMContext) -> void:
	if on_enter:
		return
	sound_effect.play()
#endregion

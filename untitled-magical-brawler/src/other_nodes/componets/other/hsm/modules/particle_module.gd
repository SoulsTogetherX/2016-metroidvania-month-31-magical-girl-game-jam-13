extends HSMModule


#region External Variables
@export_group("Modules")
@export var particle : CPUParticles2D

@export_group("Settings")
@export var on_start : bool = true
#endregion



#region Public Methods (State Change)
func start_module(_act : Node, _ctx : HSMContext) -> void:
	particle.emitting = on_start
func end_module(_act : Node, _ctx : HSMContext) -> void:
	particle.emitting = !on_start
#endregion

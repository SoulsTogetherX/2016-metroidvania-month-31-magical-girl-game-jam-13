extends VelocityTaskNode


#region External Variables
@export_group("Slowdown")
@export var slowdown_flat : float = 100.0
@export var slowdown_weight : float = 20.0

@export_group("Settings")
@export var hard_stop : bool = true
@export var reset_on_end : bool = false
#endregion


#region Private Variables
var _slowdown_flat : float
var _slowdown_weight : float
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var flat := _slowdown_flat * delta
	if hard_stop:
		if absf(velocity_module.velocity.x) <= flat:
			velocity_module.velocity.x = 0.0
			return
	
	var dir : float = signf(velocity_module.velocity.x)
	velocity_module.velocity.x = Utilities.dampf(
		velocity_module.get_velocity().x - (
			flat * dir
		),
		0.0, _slowdown_weight, delta
	)
	
	if hard_stop:
		if is_zero_approx(velocity_module.velocity.x):
			velocity_module.velocity.x = 0.0
			return
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	_slowdown_flat = args.get(&"slowdown_flat", slowdown_flat)
	_slowdown_weight = args.get(&"slowdown_weight", slowdown_weight)
	return true

func task_end() -> void:
	if !reset_on_end:
		return
	velocity_module.velocity.x = 0.0
#endregion

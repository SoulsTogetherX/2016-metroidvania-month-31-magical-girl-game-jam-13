extends VelocityTaskNode


#region External Variables
@export_subgroup("Slowdown")
@export var slowdown_flat : float = 100.0
@export var slowdown_weight : float = 20.0
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
	var dir : float = velocity_module.get_hor_direction()
	
	velocity_module.velocity.x = Utilities.dampf(
		velocity_module.get_velocity().x - (
			_slowdown_flat * dir * delta
		),
		0.0, _slowdown_weight, delta
	)
	
	if dir > 0:
		velocity_module.max_hor_velocity(0.0)
	else:
		velocity_module.min_hor_velocity(0.0)
	
	if is_zero_approx(velocity_module.velocity.x):
		force_end()
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	_slowdown_flat = args.get(&"slowdown_flat", slowdown_flat)
	_slowdown_weight = args.get(&"slowdown_weight", slowdown_weight)
	return true
func task_end() -> void:
	velocity_module.velocity.x = 0.0
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Slowdown_Task"
#endregion

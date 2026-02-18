extends VelocityTaskNode


#region External Variables
@export_subgroup("Slowdown")
@export var slowdown_flat : float = 100.0
@export var slowdown_weight : float = 20.0
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity_module := get_velocity(args)
	var dir : float = velocity_module.get_hor_direction()
	var flat : float = get_argument(
		args, &"slowdown_flat", slowdown_flat
	)
	var weight : float = get_argument(
		args, &"slowdown_weight", slowdown_weight
	)
	
	velocity_module.velocity.x = Utilities.dampf(
		velocity_module.get_velocity().x - (flat * dir * delta),
		0.0,
		weight,
		delta
	)
	
	if velocity_module.velocity.x > 0:
		velocity_module.min_hor_velocity(0.0)
		return true
	velocity_module.max_hor_velocity(0.0)
	return true
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	return get_velocity(args) != null
func task_end(args : Dictionary) -> void:
	get_velocity(args).velocity.x = 0.0
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Slowdown_Task"
#endregion

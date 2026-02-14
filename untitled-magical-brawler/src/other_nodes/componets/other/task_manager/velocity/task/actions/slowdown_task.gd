extends VelocityTaskNode


#region External Variables
@export_subgroup("Slowdown")
@export var slowdown_flat : float = 100.0
@export var slowdown_weight : float = 20.0
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity_c := get_velocity(args)
	var dir : float = velocity_c.hor_direction()
	var flat : float = args.get(&"slowdown_flat", slowdown_flat)
	var weight : float = args.get(&"slowdown_weight", slowdown_weight)
	
	velocity_c.velocity.x = Utilities.dampf(
		velocity_c.get_velocity().x - (flat * dir * delta),
		0.0,
		weight,
		delta
	)
	
	if velocity_c.velocity.x < 0:
		velocity_c.min_hor_velocity(0.0)
		return true
	velocity_c.max_hor_velocity(0.0)
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

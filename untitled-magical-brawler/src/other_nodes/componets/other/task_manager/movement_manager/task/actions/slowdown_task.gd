extends VelocityTaskNode


#region External Variables
@export_subgroup("Slowdown")
@export var slowdown_flat : float = 100.0
@export var slowdown_weight : float = 20.0
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	var dir := velocity.move_direction()
	
	velocity.lerp_hor_change(
		0.0,
		slowdown_weight,
		delta
	)
	
	velocity.flat_hor_change(-slowdown_flat * dir, delta)
	if dir < 0:
		velocity.min_hor_velocity(0.0)
	elif dir > 0:
		velocity.max_hor_velocity(0.0)
	
	return true
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	return get_velocity(args) != null
func task_end(args : Dictionary) -> void:
	var velocity := get_velocity(args)
	velocity.force_velocity_x(0.0)
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Slowdown_Task"
#endregion

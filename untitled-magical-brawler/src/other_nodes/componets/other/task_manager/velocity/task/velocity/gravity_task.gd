extends VelocityTaskNode


#region External Variables
@export_group("Modules")
@export var gravity_c : GravityComponent
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity_c := get_velocity(args)
	var grav : GravityComponent = get_argument(
		args, &"gravity", gravity_c
	)
	var on_floor : bool = get_argument(
		args, &"on_floor", false
	)
	
	grav.handle_gravity(
		velocity_c,
		!on_floor,
		delta
	)
	
	return true
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	if !(get_argument(args, &"gravity", gravity_c) is GravityComponent):
		return false
	if !(get_argument(args, &"on_floor", Callable()) is bool):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Gravity_Task"
#endregion

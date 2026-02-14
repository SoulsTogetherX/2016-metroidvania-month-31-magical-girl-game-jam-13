extends VelocityTaskNode


#region External Variables
@export_group("Modules")
@export var gravity_c : GravityComponent
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity_c := get_velocity(args)
	var grav : GravityComponent = args.get(&"gravity", gravity_c)
	var is_on_ground : Callable = args.get(&"is_on_ground", Callable())
	
	grav.handle_gravity(
		velocity_c,
		!is_on_ground.call(),
		delta
	)
	
	return true
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	
	var grav : GravityComponent = args.get(&"gravity", gravity_c)
	if grav == null:
		return false
	
	var is_on_ground : Callable = args.get(&"is_on_ground", Callable())
	if !is_on_ground.is_valid():
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Gravity_Task"
#endregion

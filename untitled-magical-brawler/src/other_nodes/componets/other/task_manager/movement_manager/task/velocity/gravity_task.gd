extends VelocityTaskNode


#region External Variables
@export_group("Modules")
@export var gravity : GravityComponent
@export var action_cache : ActionCacheComponent
#endregion



#region Public Virtual Methods
func state_physics(delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	var is_on_ground : Callable
	
	if action_cache:
		is_on_ground = action_cache.is_on_ground
	else:
		is_on_ground = args.get(&"is_on_ground")
	
	gravity.handle_gravity(
		velocity,
		!is_on_ground.call(),
		delta
	)
	
	return true
#endregion


#region Public Methods (Action States)
func begin_state(args : Dictionary) -> bool:
	return (
		get_velocity(args) != null &&
		gravity != null &&
		(
			action_cache != null ||
			(args.get(&"is_on_ground") as Callable).is_valid()
		)
	)
#endregion


#region Public Methods (Identifier)
func state_id() -> StringName:
	return &"Gravity_Task"
#endregion

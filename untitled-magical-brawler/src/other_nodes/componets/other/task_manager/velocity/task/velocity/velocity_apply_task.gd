extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func task_physics(_delta : float, args : Dictionary) -> bool:
	var velocity_module := get_velocity(args)
	var act : CharacterBody2D = get_argument(
		args, &"actor", actor
	)
	
	velocity_module.apply_velocity(act)
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	if !(get_argument(args, &"actor", actor) is CharacterBody2D):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion

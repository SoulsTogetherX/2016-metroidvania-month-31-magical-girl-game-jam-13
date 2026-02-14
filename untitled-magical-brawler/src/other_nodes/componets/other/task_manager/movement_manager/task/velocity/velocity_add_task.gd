extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : Node2D
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	var act = args.get(&"actor", actor)
	
	act.position += velocity.get_velocity() * delta
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	
	var act = args.get(&"actor", null)
	if (act == null || !(act is Node2D)) && !actor:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion

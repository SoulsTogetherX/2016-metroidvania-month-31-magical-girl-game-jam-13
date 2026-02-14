extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func task_physics(_delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	var act : CharacterBody2D = args.get(&"actor", actor)
	
	velocity.apply_velocity(act)
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	
	var act : CharacterBody2D = args.get(&"actor", actor)
	if act == null:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion

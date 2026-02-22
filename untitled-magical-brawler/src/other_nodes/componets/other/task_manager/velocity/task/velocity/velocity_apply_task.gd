extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : CharacterBody2D
#endregion


#region Private Variables
var _actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func task_physics(_delta : float) -> bool:
	velocity_module.apply_velocity(_actor)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_passthrough(args : Dictionary) -> bool:
	velocity_module = get_velocity(args)
	
	_actor = args.get(&"actor", actor)
	if _actor == null:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion

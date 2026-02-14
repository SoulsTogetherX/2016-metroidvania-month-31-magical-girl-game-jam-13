extends VelocityTaskNode


#region External Variables
@export_group("Settings")
@export var lerp_weight : Vector2 = Vector2(500.0, 500.0)

@export_group("Other")
@export var actor : Node2D
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	var act : Node2D = args.get(&"actor", actor)
	var get_tar_pos : Callable = args.get(&"get_target_pos", Callable())
	var tar_pos : Vector2 = get_tar_pos.call()
	
	var desired := VelocityComponent.damp_velocityv(
		act.global_position, tar_pos, lerp_weight, delta
	)
	velocity.force_velocity(
		desired - act.global_position
	)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	
	var act = args.get(&"actor", null)
	if (act == null || !(act is Node2D)) && !actor:
		return false
	
	var get_target = args.get(&"get_target_pos", null)
	if !(get_target is Callable) || !get_target.is_valid():
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Lerp_To_Task"
#endregion

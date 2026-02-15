extends VelocityTaskNode


#region External Variables
@export_group("Settings")
@export var lerp_weight : Vector2 = Vector2(500.0, 500.0)

@export_group("Other")
@export var actor : Node2D
@export var target : Node2D
#endregion



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity_c := get_velocity(args)
	var act : Node2D = get_argument(
		args, &"actor", actor
	)
	var tar_pos : Vector2 = _get_target_pos(args)
	var desired := Utilities.dampv(
		act.global_position, tar_pos, lerp_weight, delta
	)
	velocity_c.velocity = desired - act.global_position
	
	return true
#endregion


#region Private Methods (Helper)
func _get_target_pos(args : Dictionary) -> Vector2:
	var get_tar_pos : Variant = args.get(
		&"target_pos", null
	)
	if get_tar_pos is Vector2:
		return get_tar_pos
	if get_tar_pos is Callable && get_tar_pos.is_valid():
		return get_tar_pos.call()
	
	var tar : Node2D = args.get(&"target", target)
	if !tar:
		push_error("No target found")
		return Vector2.ZERO
	return tar.global_position
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	if !(get_argument(args, &"actor", actor) is Node2D):
		return false
	if !(_get_target_pos(args) is Vector2):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Lerp_To_Task"
#endregion

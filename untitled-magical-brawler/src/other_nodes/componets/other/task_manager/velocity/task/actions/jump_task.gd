extends VelocityTaskNode


#region External Variables
@export_group("Settings")
@export var jump_height : float = 400
@export var jump_stopper_weight : float = 0.9

@export_group("Modules")
@export var gravity_c : GravityComponent
#endregion



#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	var velocity_c := get_velocity(args)
	if !velocity_c:
		return false
	
	var grav : GravityComponent = args.get(&"gravity", gravity_c)
	if grav == null:
		return false
	
	var height : float = args.get(
		&"jump_height", jump_height
	)
	velocity_c.velocity.y = GravityComponent.get_trajectory_impulse(
		grav.gravity,
		height
	)
	return true
func task_end(args : Dictionary) -> void:
	var velocity_c := get_velocity(args)
	var stopper : float = args.get(
		&"jump_stopper_weight", jump_stopper_weight
	)
	
	if !velocity_c.attempting_fall():
		velocity_c.lerp_ver_change(0.0, stopper, 1.0)
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Jump_Task"
#endregion
